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
                                    video.toggleTorch(on: false)
                                    
                                }else {
                                    video.toggleTorch(on: true)
                                    video.startRecording()
                                }
                            }
                            
                        }
                    }
                    
                    
                    /* MARK: 카메라 변환기능 사용시 주석 해제
                    HStack {
                        Spacer()
                        
                        if !video.isTaken{
                            Button {
                                
                                common.SelectedCameraPosition = common.SelectedCameraPosition == AVCaptureDevice.Position.front ? AVCaptureDevice.Position.back : AVCaptureDevice.Position.front
                                
                                video.changeCameraPosition(position: common.SelectedCameraPosition )
                                
                            } label: {
                                Text("trnasform")
                                Image("camerachange")
                                .resizable()
                                .frame(width: 50, height: 45 )
                            }
                        }
                    }
                     */
                    
                }
                
                BottomSpacer()
                
            }
        }
        .overlay(content: {
            if let url = video.previewURL,video.showPreview{
                FinalPreview(url: url, video: video,common: common,timeRemaining:$timeRemaining, player: AVPlayer(url: url))
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
    @ObservedObject var video : VideoViewModel
    @ObservedObject var common:CameraCommon
    @Binding var timeRemaining:Int
    
    var imageManager = ImageManager()
    var player: AVPlayer
    
    var body: some View{
        GeometryReader{ proxy in
            let size = proxy.size
            
            ZStack{
                
                if timeRemaining > 0 {
                    VStack{
                        Image(systemName: "face.smiling")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .foregroundColor(Color(hex:"#FF007A"))
                        
                        Text("Video recorded duration must be 30 seconds.")
                            .font(.system(size: 32))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                        
                        Text("Please take for 30 seconds.")
                            .font(.system(size: 32))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(hex:"#FF007A"))
                    }.frame(width: 345, height: 428)
                        .background(.white)
                        .cornerRadius(10)
                    
                        .zIndex(1)
                }
                
                VideoPlayer(player: player)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .onAppear {
                        print("appear Video Player")
                        player.pause()
                    }
                
                VStack{
                    Spacer()
                    
                    ConfirmCapsule(okMessage: "Accept", noMessage: "Decline", isUseble: timeRemaining <= 0) {
                        
                        
                        if timeRemaining <= 0{
                            imageManager.saveVideo(url: url, filename: "TeethVideo")
                            common.NextStep()
                        }
                        
                    } noCallback: {
                        video.showPreview = false
                        timeRemaining = 30
                        
                    }
                    .zIndex(1)
                    
                    BottomSpacer()
                }
                
            }
            
        }
    }
    
    
}
