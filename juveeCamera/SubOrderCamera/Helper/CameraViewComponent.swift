//
//  CameraViewComponent.swift
//  juvee
//
//  Created by 이종환 on 2022/08/08.
//

import SwiftUI

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
//            Image(systemName: "camera")
//                .resizable()
//                .renderingMode(.template)
//                .aspectRatio(contentMode: .fit)
//                .foregroundColor(.white)
//                .opacity(isRecording ? 0 : 1)
//                .padding(12)
//                .frame(width: 60, height: 60)
//                .background(
//                    Circle().stroke(isRecording ? .clear : .black)
//                )
//                .padding(6)
//                .background{
//                    Circle().fill(isRecording ? .red : .white)
//                }
            
            Image(isRecording ? "startRecording" : "stopRecording")
                .resizable()
//                .renderingMode(.template)
//                .aspectRatio(contentMode: .fit)
//                .foregroundColor(.white)
//                .opacity(isRecording ? 0 : 1)
//                .padding(12)
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
                    .background(Color(hex:"#FF007A"))
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
}

struct CameraGuidelineItem: View {
    var body: some View {
        Image("guideline")
            .resizable()
            .frame(width: 200, height: 200)
            .zIndex(1)
    }
}

struct BottomSpacer: View {
    
    
    
    var body: some View {
        Spacer()
            .frame(height:100)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
