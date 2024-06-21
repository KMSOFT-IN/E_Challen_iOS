//
//  UIImageView.swift
//  PaintInTheCity
//
//  Created by KMSOFT on 24/09/20.
//  Copyright © 2020 KMSOFT. All rights reserved.
//

import Foundation
import UIKit
//import Kingfisher



extension UIImageView {

        func loadImageFromURL(url: URL, placeholderImage: UIImage? = nil) {
            self.image = placeholderImage
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }.resume()
        }
    
    func downloadImageFromUrl(imageURL: URL?,uniqueString: String = "", indexPath: IndexPath? = nil, closer: @escaping (_ image : UIImage?, _ indexPath: IndexPath?) ->(Void)) {
        
        let documentsPath = NSURL.fileURL(withPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
        //        let tempDirectoyURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
        let tempString = (uniqueString.isEmpty) ? imageURL!.lastPathComponent : uniqueString
        let path = documentsPath.appendingPathComponent(tempString)
        let fileManger = FileManager()
        let isFileExist = fileManger.fileExists(atPath: path.path)
        if !isFileExist {
            //download image
            URLSession.shared.dataTask(with: imageURL!) { (data, response, error) in
                if error == nil {
                    guard let data = data, error == nil else { return }
                    //print(“Download Finished”)
                    DispatchQueue.main.async() {
                        do {
                            _ = try data.write(to: path)
                            //self.image = UIImage(data: data)
                            closer(UIImage(data: data), indexPath)
                        }
                        catch _ {
                            closer(nil, indexPath)
                        }
                    }
                }
                else {
                    closer(nil, indexPath)
                }
            }.resume()
        }
        else {
            //take from temp directory
            URLSession.shared.dataTask(with: imageURL!) { (data, response, error) in
                if error == nil {
                    guard let data = data, error == nil else { return }
                    //print(“Download Finished”)
                    do {
                        try fileManger.removeItem(atPath: path.path)
                        _ = try data.write(to: path)
                        //self.image = UIImage(data: data)
                        DispatchQueue.main.async {
                            closer(UIImage(data: data), indexPath)
                        }
                    }
                    catch _ {
                        DispatchQueue.main.async {
                            closer(nil, indexPath)
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        closer(nil, indexPath)
                    }
                }
            }.resume()
            DispatchQueue.global(qos: .background).async {
                if let data = try? Data(contentsOf: path) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async() {
                            closer(image, indexPath)
                        }
                    }
                }
            }
        }
        
    }
}

