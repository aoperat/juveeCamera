//
//  CameraView.swift
//  juveeTest1
//
//  Created by 이종환 on 2022/07/18.
//

import SwiftUI
import AVFoundation

struct SubOrderCamera: View {
    
    @ObservedObject var common:CameraCommon
    @ObservedObject var camera:CameraViewModel
    var captureMode:enumCaptureMode
    
    var body: some View {
        
        ZStack{
            
            if !common.guideOk{
                GuideView(common: common, captureMode: captureMode)
                    .zIndex(1)
            }else{
                if common.index < 4 && !camera.isTaken{
                    CameraGuidelineItem(common: common)
                        .zIndex(1)
                }
            }
            
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack{
                Spacer()
                ZStack{
                    
                    HStack{
                        
                        if camera.isTaken{
                            
                            ConfirmCapsule(okMessage: "Accept", noMessage: "Decline")
                            {
                                camera.savePic(captureMode: captureMode)
                                common.NextStep()
                                
                            }
                            
                        noCallback: {
                            camera.reTake()
                        }
                            
                        }else{
                            
                            if common.guideOk{
                                PhotoTakeButton {
                                    camera.takePic()
                                    /*MARK: test*/
                                }
                            }
                        }
                    }
                    
                    
                    HStack {
                        
                        Spacer()
                        
                        if !camera.isTaken{
                            Button {
                                
                                common.SelectedCameraPosition = common.SelectedCameraPosition == AVCaptureDevice.Position.front ? AVCaptureDevice.Position.back : AVCaptureDevice.Position.front
                                
                                camera.changeCameraPosition(position: common.SelectedCameraPosition )
                                
                            } label: {
                                //Text("trnasform")
                                Image("camerachange")
                                    .resizable()
                                    .frame(width: 50, height: 45 )
                                
                            }

                        }
                        
                    }
                }
                
                BottomSpacer()
                
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


