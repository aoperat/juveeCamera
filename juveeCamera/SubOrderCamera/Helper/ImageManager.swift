//
//  ImageManager.swift
//  juvee
//
//  Created by 이종환 on 2022/07/27.
//

import Foundation
import UIKit

class ImageManager {
    static let shared = ImageManager()
    
    
    func getDirtory() -> URL{
        var directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        directory = directory.appendingPathComponent("NewDirectory")
        
        do {
            try FileManager.default.createDirectory(at: directory as URL, withIntermediateDirectories: false, attributes: nil)
        } catch let e {
            print(e.localizedDescription)
        }
        
        return directory
    }
    
    func saveImage(image: UIImage,filename:String) -> Bool {
        
        let directory =  getDirtory()
        
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        
        do {
            try data.write(to: directory.appendingPathComponent(filename))
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func saveVideo(url: URL,filename:String) -> Bool {
        
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("NewDirectory" + "/" + filename)
        
        do{
            let videoData = try Data(contentsOf: url)
            fileManager.createFile(atPath: paths as String, contents: videoData, attributes: nil)
            return true
        }catch{
            print(error.localizedDescription)
            return false
        }
    }
    
    
}
