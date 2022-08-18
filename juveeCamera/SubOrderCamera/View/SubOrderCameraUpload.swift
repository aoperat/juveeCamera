//
//  SubOrderCameraUploadView.swift
//  juvee
//
//  Created by 이종환 on 2022/08/04.
//

import SwiftUI
import Alamofire

struct SubOrderCameraUploadView: View {
    var body: some View {
        VStack{
            Button {
                
                //fileUpload()
                
            } label: {
                Text("Test")
            }
            
        }
    }
//
//    var baseUrl: URL {
//        return URL(string: ApiClient.BASE_URL)!
//    }
    var baseUrl: URL {
        return URL(string: "http://20.228.174.105")!
    }

    
    func readFileList() -> Array<String> {
        
        var arr: Array = [""]
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("NewDirectory") as NSURL else {
            return arr
        }
        
        arr.removeAll()
        
        do{
            let items = try FileManager.default.contentsOfDirectory(atPath: directory.path ?? "")
            
            if items.count > 0 {
                for item in items {
                    
                    //let insertstring:String = "\(directory)\(item)"
                    arr.insert(item, at:arr.endIndex)
                }
            }
            
            return arr
        }catch {
            print(error.localizedDescription)
            return arr
        }
    }
    
//    func fileUpload() {
//        print("button clicked...")
//
//        let requestURL = baseUrl.absoluteString+"/api/uploadTest"
//        let header : HTTPHeaders = [
//            "Content-Type" : "multipart/form-data",
//            "newApiKey":UserDefaultManager.shared.getApiKey()]
//
//        var directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        directory = directory.appendingPathComponent("NewDirectory")
//
//
//        AF.upload(multipartFormData: { multipartFormData in
//
//            var videoIndex = 1
//            var imageIndex = 1
//
//            for (index, file) in readFileList().enumerated(){
//
//                let extn = file.split(separator: ".")[1]
//                if ["mov","mp4"].contains(extn) {
//                    multipartFormData.append(directory.appendingPathComponent(file), withName: "\(file)\(index)", fileName: "\(file).mp4", mimeType: "video/mov")
//
//                }else if ["jpg","jpeg","png"].contains(extn){
////                    multipartFormData.append(directory.appendingPathComponent(file), withName: "\(file)\(index)", fileName: "image\(imageIndex).jpg", mimeType: "image/jpg")
//                    multipartFormData.append(directory.appendingPathComponent(file), withName: "\(file)\(index)", fileName: "\(file).jpg", mimeType: "image/jpg")
//                }
//
//            }
//
//
//        }, to: requestURL, usingThreshold: UInt64.init(), method: .post, headers: header).response { response in
//            guard let statusCode = response.response?.statusCode,
//                  statusCode == 200
//            else {
//                print("🥲 error xxxx")
//                print(response.error?.localizedDescription)
//                return }
//            print(":::: successed ::::")
//
//        }
//    }
    
    func clearTempFolder() {
        let fileManager = FileManager.default
        let tempFolderPath = NSTemporaryDirectory()
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: tempFolderPath + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }

}
