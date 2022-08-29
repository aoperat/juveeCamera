//
//  SubOrderCameraView.swift
//  juvee
//
//  Created by IDINO on 2022/07/26.
//

import SwiftUI
import Alamofire

struct SubOrderCameraView: View {
    
    //    @Binding var viewId: CGFloat
    //    @Binding var showDetail: Bool
    //    @State var geoSize: CGSize
    
    var imageManager = ImageManager()
    
    @StateObject var common:CameraCommon = CameraCommon()
    @StateObject var camera:CameraViewModel = CameraViewModel()
    @StateObject var video:VideoViewModel = VideoViewModel()
    
    var body: some View {
        
        switch common.index{
        case 1:
            SubOrderCamera(common: common, camera: camera,captureMode:.photo)
        case 2:
            SubOrderCamera(common: common, camera: camera,captureMode:.photoWithCard)
        case 3:
            HomeView(common: common, video: video,captureMode: .video)
        case 4:
            SubOrderCameraUploadView()
            
        default:
            Text("Error :: SubOrderCameraView")
        }
    }
}
