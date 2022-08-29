//
//  SelectTargetView.swift
//  juvee
//
//  Created by 이종환 on 2022/08/05.
//

import SwiftUI

struct SelectTargetView: View {
    @ObservedObject var common:CameraCommon
    @ObservedObject var camera:CameraViewModel
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .fill(Color.white)
                .opacity(0.5)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                
                CustomButton(label:"FRONT" , image: Image(systemName: "face.smiling")) {
                    common.setPostion(position: .front)
                    common.NextStep()
                }
                
                CustomButton(label:"BACK", image: Image(systemName: "face.smiling")){
                    common.setPostion(position: .back)
                    common.NextStep()
                }
                
            }
        }
    }
}

struct CustomButton: View {
    
    var label: String
    var image: Image
    var action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                VStack{
                    image
                        .resizable()
                        .frame(width: 150, height: 150)
                        .foregroundColor(Color.white)
                    
                    Text(label)
                        .font(.system(size: 32))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                }
            }
        }
        
        .frame(width: 345, height: 428/2)
        .background(Color(hex:CustomColors.pink.rawValue))
        .cornerRadius(10)
    }
}

enum CustomColors: String{
    case pink = "#FF007A"
}
