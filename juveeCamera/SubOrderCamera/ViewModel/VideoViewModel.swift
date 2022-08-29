//
//  VideoViewModel.swift
//  Videotuto
//
//  Created by 이종환 on 2022/07/14.
//

import SwiftUI
import AVFoundation

//MARK: ObservableObject
//ObservableObject를 사용하면 해당 클래스의 인스턴스를 관찰하고 있다가 값이 변경될 때 뷰를 업데이트한다.
//@Published 로 선언된 속성이 ObservableObject 에 포함되어 있다면 해당 속성이 업데이트 될 때마다 뷰를 업데이트 한다.
class VideoViewModel: NSObject,ObservableObject,AVCaptureFileOutputRecordingDelegate{
    
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCaptureMovieFileOutput()
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    // MARK: Video Recorder Properties
    @Published var isRecording: Bool = false
    @Published var recordedURLs: [URL] = []
    @Published var previewURL: URL?
    @Published var showPreview: Bool = false
    
    func checkPermission(position: AVCaptureDevice.Position){
        
        switch AVCaptureDevice.authorizationStatus(for: .video){
            
        case .authorized:
            setUp(position: position)
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video){(status) in
                if status{
                    self.setUp(position: position)
                }
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func setUp(position:AVCaptureDevice.Position){
        
        do{
            self.session.beginConfiguration()//begin
            
            let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera,for: .video, position: position)
            
            let videoInput = try AVCaptureDeviceInput(device: cameraDevice!)
            let audioDevice = AVCaptureDevice.default(for: .audio)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice!)
            
            
            if self.session.canAddInput(videoInput) && self.session.canAddInput(audioInput){
                self.session.addInput(videoInput)
                self.session.addInput(audioInput)
            }
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
                
            }
            
            self.session.commitConfiguration() //commut
            self.session.startRunning()
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func changeCameraPosition(position:AVCaptureDevice.Position){
        do{
            self.session.beginConfiguration()
            
            session.removeInput(session.inputs[0])
            
            session.removeInput(session.inputs[0])
            
            
            let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera,for: .video, position: position)
            
            let videoInput = try AVCaptureDeviceInput(device: cameraDevice!)
            let audioDevice = AVCaptureDevice.default(for: .audio)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice!)
            
            if self.session.canAddInput(videoInput) && self.session.canAddInput(audioInput){
                self.session.addInput(videoInput)
                self.session.addInput(audioInput)
            }
            
            self.session.commitConfiguration()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    func startRecording(){
        
        let tempURL = NSTemporaryDirectory() + "\(Date()).mov"
        
        
        output.startRecording(to: URL(fileURLWithPath: tempURL), recordingDelegate: self)
        
        
        isRecording = true
    }
    
    func stopRecording(){
        output.stopRecording()
        isRecording = false
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        print(":::fileOutput:::")
        print(outputFileURL)
        self.previewURL = outputFileURL
    }
}
