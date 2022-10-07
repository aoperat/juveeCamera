//
//  CameraViewComponent.swift
//  juvee
//
//  Created by 이종환 on 2022/08/08.
//

import SwiftUI
import UIScreenExtension

//MARK: Button
struct PhotoTakeButton: View {
    
    var action: ()->()
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            
            ZStack{
                Circle()
                    .fill(Color.white)
                    .frame(width: 65, height: 65)
                Circle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: 75.0, height: 75)
            }
        })
    }
}


struct VideoTakeButton: View {
    
    @Binding var isRecording: Bool
    var action: () -> ()
    
    var body: some View {
        Button{
            action()
        } label:{
            Image(isRecording ? "stopRecording" : "startRecording")
                .resizable()
                .frame(width: 75, height: 75)
        }//End of Button
    }
}



struct Countdown: View {
    
    @Binding var timeRemaining: Int
    var action: () -> ()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        VStack(){
            
            Spacer()
                .frame(height: 10)
            
            HStack{
                
                Spacer()
                    .frame(width: 10)
                if timeRemaining > 0{
                    Text("\(timeRemaining)")
                        .font(.system(size: 80))
                    .fontWeight(.bold)}
                else if timeRemaining == 0 {
                    Text("End recording")
                        .font(.system(size: 80))
                        .fontWeight(.bold)
                }else{
                    Text("")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                
                Spacer()
            }
            Spacer()
        }.onReceive(timer) { _ in
            action()
        }
        
    }
}

struct ConfirmCapsule: View {
    
    @State var okMessage: String
    @State var noMessage: String
    @State var isUseble = true
    var okCallback : () -> ()
    var noCallback : () -> ()
    
    
    var body: some View {
        
        HStack(spacing:1){
            
            Button {
                
                okCallback()
                
            } label: {
                Text(okMessage)
                    .font(.system(size: 17))
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                    .frame(width: 295/2, height: 45)
                    .background(Color(hex: getButtonColor(isUseble:isUseble)))
                    .cornerRadius(50, corners: .topLeft)
                    .cornerRadius(50, corners: .bottomLeft)
            }
            
            Button{
                noCallback()
            }label: {
                Text(noMessage)
                    .font(.system(size: 17))
                    .fontWeight(.regular)
                    .foregroundColor(Color(hex:"#FF007A"))
                    .frame(width: 295/2, height: 45)
                    .background(.white)
                    .cornerRadius(50, corners: .topRight)
                    .cornerRadius(50, corners: .bottomRight)
                
            }
            
        }.offset(y: -20)
    }
    
    func getButtonColor(isUseble:Bool) -> String{
        
        print(isUseble)
        
        if isUseble {
            return "#FF007A"
        } else{
            return "#808080"
        }
    }
}

struct CameraGuidelineItem: View {
    
    @ObservedObject var common:CameraCommon
    
    
    let ppi = UIScreen.pointsPerInch!
    let ppc = UIScreen.pointsPerCentimeter!
    var body: some View {
        
        GeometryReader {geo in
            
            //vertical 53.98 / 153.0141
            //horizontal 85.6 / 242.6455
            // 186.51
            
            if common.index == 2 {
                Image("guide-img\(common.index)")
//                    .resizable()
//                    .frame(width: 5.398 * ppc, height: 18.651 * ppc)
                    .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
            }else{
                Image("guide-img\(common.index)")
                    .frame(width: geo.size.width)
                    .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
            }
            
            
            

        }.zIndex(1)
        
    }
}

struct BottomSpacer: View {
    
    var body: some View {
        Spacer()
            .frame(height:100)
    }
}

struct GuideView: View {
    
    @ObservedObject var common:CameraCommon
    var captureMode : enumCaptureMode
    
    var body: some View {
        
        ZStack {
            
            Rectangle()
                .fill(Color.black)
                .opacity(0.5)
                .ignoresSafeArea(.all, edges: .all)
            
            
            VStack {
                HStack {
                    
                    switch captureMode{
                    case .photo:
                        VStack{
                            Image(systemName: "face.smiling")
                                .resizable()
                                .frame(width: 150, height: 150)
                                .foregroundColor(Color(hex:"#FF007A"))
                            
                            Text("Take a picture")
                                .font(.system(size: 32))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                            
                            Text("to show your teeth")
                                .font(.system(size: 32))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                            
                        }
                        
                    case .photoWithCard:
                        VStack{
                            Image(systemName: "face.smiling")
                                .resizable()
                                .frame(width: 150, height: 150)
                                .foregroundColor(Color(hex:"#FF007A"))
                            
                            Text("Take a picture")
                                .font(.system(size: 32))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                            Text("to show your teeth")
                                .font(.system(size: 32))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                            Text("with Credit card")
                                .font(.system(size: 32))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(hex:"#FF007A"))
                            
                        }
                    case .video:
                        VStack{
                            Image(systemName: "face.smiling")
                                .resizable()
                                .frame(width: 150, height: 150)
                                .foregroundColor(Color(hex:"#FF007A"))
                            
                            Text("Take a video")
                                .font(.system(size: 32))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                            Text("to show your teeth")
                                .font(.system(size: 32))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                            Text("for 30 seconds")
                                .font(.system(size: 32))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(hex:"#FF007A"))
                        }
                        
                    default:
                        VStack{
                            Text("No Guide")
                        }
                        
                    }
                }
                .frame(width: 345, height: 428)
                .background(.white)
                .cornerRadius(10)
                
                Button(action: {
                    common.guideOk = true
                }, label: {
                    Text("Ok")
                        .font(.system(size: 17))
                        .fontWeight(.regular)
                        .padding()
                        .foregroundColor(.white)
                        .frame(width: 295, height: 45)
                        .background(Color(hex:"#FF007A"))
                        .cornerRadius(20)
                    
                    
                })
                .offset(y:30)
                
                
            }
        }
        
    }
}
