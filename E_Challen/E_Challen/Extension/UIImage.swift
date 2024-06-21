//
//  UIImage.swift
//  Bizook
//
//  Created by Akash Trivedi on 06/06/18.
//  Copyright © 2018 Akash Trivedi. All rights reserved.
//

import Foundation
import UIKit
import Photos

extension UIImage {
    
    static func load(url: URL, to localUrl: URL, completion: @escaping () -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url: url)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                    completion()
                } catch (let writeError) {
                    print("error writing file \(localUrl) : \(writeError)")
                    completion()
                }
                
            } else {
                completion()
                print("Failure: %@", error?.localizedDescription ?? "");
            }
        }
        task.resume()
    }
    
    func saveToDocuments(filename:String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        if let data = self.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: fileURL)
            } catch {
                print("error saving file to documents:", error)
            }
        }
    }
    
    func resizeImageLimite(targetSize: CGSize) -> UIImage {
        let image = self
        let size = image.size
        
        if(targetSize.width > size.width && targetSize.height > size.height){
            return self
        }
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.9)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func fixOrientation() -> UIImage {
        
        // No-op if the orientation is already correct
        if ( self.imageOrientation == UIImage.Orientation.up ) {
            return self;
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        if ( self.imageOrientation == UIImage.Orientation.down || self.imageOrientation == UIImage.Orientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }
        
        if ( self.imageOrientation == UIImage.Orientation.left || self.imageOrientation == UIImage.Orientation.leftMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2.0))
        }
        
        if ( self.imageOrientation == UIImage.Orientation.right || self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi / 2.0));
        }
        
        if ( self.imageOrientation == UIImage.Orientation.upMirrored || self.imageOrientation == UIImage.Orientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if ( self.imageOrientation == UIImage.Orientation.leftMirrored || self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!;
        
        ctx.concatenate(transform)
        
        if ( self.imageOrientation == UIImage.Orientation.left ||
            self.imageOrientation == UIImage.Orientation.leftMirrored ||
            self.imageOrientation == UIImage.Orientation.right ||
            self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(cgImage: ctx.makeImage()!)
    }
    
}
extension UIImageView{
        
    func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize, indexPath: IndexPath? = nil, callback:((_ indexPath: IndexPath?,_ phImage: UIImage)-> Void)?) {
        //        let options = PHImageRequestOptions()
        //        options.version = .original
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        option.isSynchronous = true
        option.resizeMode = .fast
        
        PHCachingImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: option) { (image, _) in
            guard let image = image else { return }
            switch contentMode {
            case .aspectFill:
                self.contentMode = .scaleAspectFill
                break
            case .aspectFit:
                self.contentMode = .scaleAspectFit
                break
            default:
                break
            }
            callback?(indexPath, image)
        }
        //        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: option) { image, _ in
        //            guard let image = image else { return }
        //            switch contentMode {
        //            case .aspectFill:
        //                self.contentMode = .scaleAspectFill
        //            case .aspectFit:
        //                self.contentMode = .scaleAspectFit
        //            }
        //            self.image = image
        //        }
    }
}
extension PHAsset {
    func getImage(callback:((_ phData: Data)-> Void)?) {
        //        let options = PHImageRequestOptions()
        //        options.version = .original
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        option.isSynchronous = true
        option.resizeMode = .fast
        
        /*PHCachingImageManager.default().requestImageData(for: self, options: nil) { (data, type, orientation, options) in
            guard let data = data else { return }
            callback?(data)
        }*/
        PHCachingImageManager.default().requestImageDataAndOrientation(for: self, options: option) { (data: Data?, type: String?, orientation: CGImagePropertyOrientation, options: [AnyHashable : Any]?) in
            guard let data = data else { return }
            callback?(data)
        }
    }
}

extension String {
    func getImage()-> UIImage {
        let fileManager = FileManager.default
        let imagePath = (self.getDirectoryPath() as NSString).appendingPathComponent(self)
        if fileManager.fileExists(atPath: imagePath){
            return UIImage(contentsOfFile: imagePath)!
        }else{
            print("No Image available")
            return UIImage.init(named: "ic_placeholder")!
        }
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

extension UIImage {
    
    func convertImageToBase64String(img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    func convertBase64StringToImage(imageBase64String: String) -> UIImage {
        guard let imageData = Data(base64Encoded: imageBase64String) else {
            return UIImage()
        }
        let image = UIImage(data: imageData) ?? UIImage()
        return image
    }
    
}
