//
//  Home.swift
//  Videotuto
//
//  Created by 이종환 on 2022/07/14.
//

import SwiftUI
import AVKit
import AVFoundation

import Alamofire

struct HomeView : View {
    
    @ObservedObject var common:CameraCommon
    @ObservedObject var video:VideoViewModel
    @State var timeRemaining :Int = 30
    var captureMode : enumCaptureMode
    
    //@State var timeRemaining = 5
    //let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View{
        ZStack{
            
            if !common.guideOk{
                GuideView(common: common,captureMode: captureMode)
                    .zIndex(1)
                
            }else{
                
                if common.index < 4 && !video.showPreview{
                    CameraGuidelineItem(common: common)
                }
                
                Countdown(timeRemaining: $timeRemaining,action: {
                    if video.isRecording && timeRemaining >= 0 {
                        timeRemaining -= 1
                    }else{
                        if video.isRecording{
                            video.stopRecording()
                            video.showPreview.toggle()
                            //timeRemaining = 5
                            timeRemaining = 30
                        }
                        
                    }
                })
                .zIndex(1)
                
            }
            
            VideoView(common: common, video: video)
                //.environmentObject(common,video)
            
            VStack{
                Spacer()
                
                
                ZStack{
                    HStack{
                        if !video.isTaken{
                            
                            VideoTakeButton(isRecording: $video.isRecording) {
                                if video.isRecording{
                                    video.stopRecording()
                                    video.showPreview.toggle()
                                    timeRemaining = 30
                                }else {
                                    video.startRecording()
                                }
                            }
                            
                        }
                    }

                    
                    HStack {
                        
                        Spacer()
                        
                        if !video.isTaken{
                            Button {
                                
                                common.SelectedCameraPosition = common.SelectedCameraPosition == AVCaptureDevice.Position.front ? AVCaptureDevice.Position.back : AVCaptureDevice.Position.front
                                
                                video.changeCameraPosition(position: common.SelectedCameraPosition )
                                
                            } label: {
                                //Text("trnasform")
                                Image("camerachange")
                                    .resizable()
                                    .frame(width: 50, height: 45 )
                                
                            }

                        }
                        
                    }                }
                                
                BottomSpacer()
                
            }
        }
        .overlay(content: {
            if let url = video.previewURL,video.showPreview{
                FinalPreview(url: url, video: video,common: common)
                    .transition(.move(edge: .trailing))
            }
        })
        .animation(.easeInOut, value: video.showPreview)
        .preferredColorScheme(.dark)
        
    }
}

struct VideoView: View {
    
    @ObservedObject var common:CameraCommon
    @ObservedObject var video: VideoViewModel
    
    var body: some View {
        
        GeometryReader{proxy in
            let size = proxy.size
            
            VideoPreview(size: size)
                .environmentObject(video)
        }
        .onAppear{
            video.checkPermission(position: common.getPostion())
        }
        .alert(isPresented: $video.alert){
            Alert(title: Text("Please Enable CameraViewModel Access"))
        }
    }
}

struct VideoPreview: UIViewRepresentable{
    
    @EnvironmentObject var video : VideoViewModel
    var size: CGSize
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        video.preview = AVCaptureVideoPreviewLayer(session: video.session)
        video.preview.frame.size = size
        
        video.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(video.preview)
        
        video.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct FinalPreview: View{
    
    var url: URL
    //@Binding var showPreview: Bool
    @ObservedObject var video : VideoViewModel
    @ObservedObject var common:CameraCommon
    var imageManager = ImageManager()
    
    var body: some View{
        GeometryReader{ proxy in
            let size = proxy.size
            
            ZStack{
                VideoPlayer(player: AVPlayer(url: url))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                
                VStack{
                    Spacer()
                    
                    ConfirmCapsule(okMessage: "Accept", noMessage: "Decline") {
                        
                        //UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil)
                        imageManager.saveVideo(url: url, filename: "TeethVideo.mp4")
                        common.NextStep()
                        
                    } noCallback: {
                        video.showPreview.toggle()
                        
                    }
                    .zIndex(1)
                    
                    BottomSpacer()
                }
                
            }
            
        }
    }
}
