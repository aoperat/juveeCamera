//
//  Extension.swift
//  juveeCamera
//
//  Created by 이종환 on 2022/08/19.
//

import Foundation
import SwiftUI

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

struct CircularProgressView: View {
    // 1
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color(hex:"#FF007A").opacity(0.5),
                    lineWidth: 20
                )
            Circle()
                // 2
                .trim(from: 0, to: progress)
                .stroke(
                    Color(hex:"#FF007A"),
                    style: StrokeStyle(
                        lineWidth: 20,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
        }
    }
}
