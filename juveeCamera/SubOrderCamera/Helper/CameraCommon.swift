//
//  CommonViewModel.swift
//  juveeTest1
//
//  Created by 이종환 on 2022/07/19.
//

import Foundation
import SwiftUI
import AVFoundation

class CameraCommon:ObservableObject {
    
    @Published var index: Int = 1
    @Published var guideOk: Bool = false
    @Published var SelectedCameraPosition: AVCaptureDevice.Position = .unspecified
    
    
    func NextStep(){
        index += 1
        guideOk = false
    }
    
    func setPostion(position:AVCaptureDevice.Position){
        self.SelectedCameraPosition = position
    }
    
    func getPostion()->AVCaptureDevice.Position {
        
        return self.SelectedCameraPosition
    }
}

enum enumCaptureMode : Int {
    case none = 0
    case photo = 1
    case photoWithCard = 2
    case video = 3
}

extension UIImage {
    
//    let ppc = UIScreen.pointsPerCentimeter!
    
    func mergeWith(topImage: UIImage) -> UIImage {
        let bottomImage = self
        
        UIGraphicsBeginImageContext(size)
        
//            .frame(width: 5.398 * ppc, height: 18.651 * ppc)
//            .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
        
        
        let areaSize = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)
        bottomImage.draw(in: areaSize)
        
        let topWidth = 5.398 * UIScreen.pixelsPerCentimeter!
        let topHeight = 18.651 * UIScreen.pixelsPerCentimeter!
        
        let topAreaSize = CGRect(x: (bottomImage.size.width/2) - (topWidth/2), y: (bottomImage.size.height/2) - (topHeight/2), width: topWidth, height: topHeight)
        topImage.draw(in: topAreaSize, blendMode: .normal, alpha: 1.0)
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return mergedImage
    }
}
