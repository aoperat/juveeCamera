//
//  CameraView.swift
//  juveeTest1
//
//  Created by 이종환 on 2022/07/18.
//

import SwiftUI
import AVFoundation
import UIScreenExtension

struct SubOrderCamera: View {
    
    @ObservedObject var common:CameraCommon
    @ObservedObject var camera:CameraViewModel
    var captureMode:enumCaptureMode
    
    let ppc = UIScreen.pointsPerCentimeter!
    
    var body: some View {
        
        ZStack{
            
            if !common.guideOk{
                GuideView(common: common, captureMode: captureMode)
                    .zIndex(1)
            }else{
                
                if camera.isTaken{
                    
                    
                    VStack{
                        Spacer()
                        
                        
                        ConfirmCapsule(okMessage: "Accept", noMessage: "Decline")
                        {
                            camera.savePic(captureMode: captureMode)
                            common.NextStep()
                            
                        } noCallback: {
                            camera.reTake()
                        }
                        
                        BottomSpacer()
                    }.zIndex(3)
                    
                    
                    GeometryReader {geo in
                        
                        if common.index == 2 {
                            Image("guide-img2-1")
//                                .resizable()
//                                .frame(width: 5.398 * ppc, height: 18.651 * ppc)
                                .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
                        }
                    }.zIndex(2)
                    
                    
                }else{
                    if common.index < 4{
                        CameraGuidelineItem(common: common)
                            .zIndex(1)
                    }
                    
                    
                    VStack{
                        Spacer()
                        
                        if camera.Luxlev > 100{
                            PhotoTakeButton {
                                
                                camera.toggleTorch(on: true)
                                camera.takePic()
                            }
                        }else{
                                Text("It's too dark")
                                    .font(.system(size: 17))
                                    .fontWeight(.regular)
                                    .padding()
                                    .foregroundColor(.white)
                                    .frame(width: 295, height: 45)
                                    .background(Color.black)
                                    .cornerRadius(20)
                                    .opacity(0.7)
                            
                                
                        }
                        
                        BottomSpacer()
                    }.zIndex(2)
                    //                    Button {
                    //
                    //                        common.SelectedCameraPosition = common.SelectedCameraPosition == AVCaptureDevice.Position.front ? AVCaptureDevice.Position.back : AVCaptureDevice.Position.front
                    //
                    //                        camera.changeCameraPosition(position: common.SelectedCameraPosition )
                    //
                    //                    } label: {
                    //                        //Text("trnasform")
                    //                        Image("camerachange")
                    //                            .resizable()
                    //                            .frame(width: 50, height: 45 )
                    //
                    //                    }
                    
                }
                
            }
            
            
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack{
                
            }.padding(.horizontal,10)
                .zIndex(2)
        }
        .onAppear{
            camera.checkPermission(position: common.getPostion())
        }
    }
    
}

//MARK: setting view for preview...
// UIViewRepresentable 사용 시 UIKit view 를 SwiftUI에서 사용할 수 있도록 랩핑해준다.
struct CameraPreview: UIViewRepresentable {
    
    /* **ObservableObject (클래스에서 사용)**
     > ObservableObject를 사용하면 해당 클래스의 인스턴스를 관찰하고 있다가 값이 변경될 때 뷰를 업데이트한다.*/
    @ObservedObject var camera : CameraViewModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        //Your Own Properties...
        camera.preview.videoGravity = . resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}


