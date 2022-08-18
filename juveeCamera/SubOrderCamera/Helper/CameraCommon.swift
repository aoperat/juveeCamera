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
