//
//  CameraViewModel.swift
//  juveeTest1
//
//  Created by 이종환 on 2022/07/18.
//

import SwiftUI
import AVFoundation

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate{
    
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var videoOutput = AVCaptureVideoDataOutput()
    private let videoSampleBufferQueue = DispatchQueue(label: "videoSampleBufferQueue")
    @Published var preview : AVCaptureVideoPreviewLayer!
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    @Published var cameraPosition :AVCaptureDevice.Position = .front
    @Published var Luxlev: Int = 0
    
    @ObservedObject var common = CameraCommon()
    var imageManager = ImageManager()
    
    func checkPermission(position:AVCaptureDevice.Position){
        
        switch AVCaptureDevice.authorizationStatus(for: .video){
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video){ (status) in
                if status{
                    self.setUp(position: position)
                }
            }
        case .denied:
            self.alert.toggle()
        case .authorized:
            setUp(position: position)
            return
        default:
            return
        }
        
    }
    
    func setUp(position:AVCaptureDevice.Position){
        print(":::: setUp :::: \(position)")
        
        do{
            self.session.beginConfiguration()
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
            
            let input = try AVCaptureDeviceInput(device: device!)
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            if self.session.canAddOutput(self.videoOutput){
                self.session.addOutput(self.videoOutput)
            }
            videoOutput.setSampleBufferDelegate(self, queue: videoSampleBufferQueue)
            
            self.session.commitConfiguration()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func changeCameraPosition(position:AVCaptureDevice.Position){
        do{
            self.session.beginConfiguration()
            
            session.removeInput(session.inputs[0])
            print(position)
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
            let input = try AVCaptureDeviceInput(device: device!)
            
            if session.canAddInput(input){
                session.addInput(input)
            }
            
            self.session.commitConfiguration()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }

    
    func takePic(){
        DispatchQueue.global(qos: .background).async {
            
            let photoSettings = AVCapturePhotoSettings()
            
            //photoSettings.flashMode = .on
            
            
            self.output.capturePhoto(with: photoSettings, delegate: self)
            DispatchQueue.main.async {
                
                withAnimation{self.isTaken.toggle()}
            }
        }
    }
    
    func reTake(){
        
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async{
                withAnimation{
                    self.isTaken = false
                }
                self.isSaved = false
            }
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil { return }
        guard let imageData = photo.fileDataRepresentation() else{return}
        
        
        self.picData = imageData
        self.session.stopRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        // Handle the pixelBuffer the way you like
        //print("pixelBuffer::++ \(pixelBuffer)")
        
        let dict: NSDictionary = pixelBuffer.attachments.propagated["MetadataDictionary"]! as! NSDictionary

        
        //print(dict)
        DispatchQueue.main.async {
            self.Luxlev = dict["LuxLevel"] as! Int
        }
        
        
    }

    
    func savePic(captureMode : enumCaptureMode ){
        

        var image = UIImage(data: self.picData)!
        
        if captureMode == .photoWithCard {
            image = image.mergeWith(topImage: UIImage(named: "guide-img2-1")!)
        }
        
        if(imageManager.saveImage(image: image,filename: "\(captureMode == .photo ? "SmilePhoto" : "MeasurePhoto")")){
            print("saved Successfully...")
        }else{
            print("save failed")
        }
        
        self.isTaken = false
    }
    
    func captureOutput(_ captureOutput: AVCapturePhotoOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {

        //Retrieving EXIF data of camara frame buffer
        let rawMetadata = CMCopyDictionaryOfAttachments(allocator: nil, target: sampleBuffer, attachmentMode: CMAttachmentMode(kCMAttachmentMode_ShouldPropagate))
        let metadata = CFDictionaryCreateMutableCopy(nil, 0, rawMetadata) as NSMutableDictionary
        let exifData = metadata.value(forKey: "{Exif}") as? NSMutableDictionary

        let FNumber : Double = exifData?["FNumber"] as! Double
        let ExposureTime : Double = exifData?["ExposureTime"] as! Double
        let ISOSpeedRatingsArray = exifData!["ISOSpeedRatings"] as? NSArray
        let ISOSpeedRatings : Double = ISOSpeedRatingsArray![0] as! Double
        let CalibrationConstant : Double = 50

        //Calculating the luminosity
        let _ : Double = (CalibrationConstant * FNumber * FNumber ) / ( ExposureTime * ISOSpeedRatings )

        
    }
 
    func setCameraPoistion(position: AVCaptureDevice.Position){
        self.cameraPosition = position
        print("setCameraPostion(\(cameraPosition))")
        
    }
}

