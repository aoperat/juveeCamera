//
//  SubOrderCameraUploadView.swift
//  juvee
//
//  Created by 이종환 on 2022/08/04.
//

import SwiftUI
import Alamofire

struct SubOrderCameraUploadView: View {
    @State private var showingAlert = false
    @State var progressValue : Double = 0.0
    
    var body: some View {
//                    Text("upload")
//                    ProgressView(value:progressValue,total:1).padding(.horizontal,10)
            VStack {
                HStack {
                    CircularProgressView(progress: progressValue)
                                .frame(width: 150, height: 150)

                }
                .frame(width: 345, height: 345)
                .background(.white)
                .cornerRadius(10)
                
                                        
                
            }.onAppear{
                fileUpload()
            }.alert(isPresented: $showingAlert){
                Alert(title: Text("Success"), message: Text("files are uploaded"), dismissButton: .default(Text("Dismiss")))
            }
            
    }

    var baseUrl: URL {
        //        return URL(string: ApiClient.BASE_URL)!
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
    
    func fileUpload() {
        
        print("button clicked...")

        let requestURL = baseUrl.absoluteString+"/api/uploadPhotoFileOniOS"
        let header : HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "newApiKey":"5a928987-b1e6-4813-bdcd-b4e6e5c3cc4e"]

        var directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        directory = directory.appendingPathComponent("NewDirectory")


        AF.upload(multipartFormData: { multipartFormData in

            for (index, file) in readFileList().enumerated(){

                //let extn = file.split(separator: ".")[1]
                if ["TeethVideo"].contains(file) {
                    multipartFormData.append(directory.appendingPathComponent(file), withName: "\(file)\(index)", fileName: "\(file).mp4", mimeType: "video/mov")

                }else if ["MeasurePhoto","SmilePhoto"].contains(file){
                    multipartFormData.append(directory.appendingPathComponent(file), withName: "\(file)\(index)", fileName: "\(file).jpg", mimeType: "image/jpg")
                }

            }


        }, to: requestURL, usingThreshold: UInt64.init(), method: .post, headers: header)
        
        .uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                        progressValue = progress.fractionCompleted
                    })
        
        .responseString { response in
            guard let statusCode = response.response?.statusCode,
                  statusCode == 200
            else {
                print("🥲 error xxxx")
                print(response.error?.localizedDescription ?? "")
                return }
            print(":::: successed ::::")
            showingAlert = true

        }
        
    }
    
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


