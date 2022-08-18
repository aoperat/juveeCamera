//
//  GuideView.swift
//  juveeTest1
//
//  Created by 이종환 on 2022/07/20.
//

import SwiftUI

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
                            Text("for 5 seconds")
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
        //.background(Color(hex: "#ECEFF2"))
    }
}

extension Color{
    init(hex: String){
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double((rgb >> 0) & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue:b)
    }
}
