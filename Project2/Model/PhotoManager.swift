//
//  PhotoManager.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/7.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import Foundation
import Photos

protocol PhotoManagerDelegate: AnyObject {
    
    var imageArray: [UIImage] { get set }
    var imageURL: [URL]  { get set }

    func setupImage()
 
}

class PhotoManager {
    
    weak var delegate: PhotoManagerDelegate?
    
    func grabPhoto() {
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 100
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        
        
            if fetchResult.count > 0 {
                
                DispatchQueue.global().async {
                    
                    
                    for i in 0..<fetchResult.count {
                        
                        guard let asset = fetchResult.object(at: i) as? PHAsset else { return }
                        ////
                        //      //              存 URL >> 在用 kinfisher 去顯示在 collection view cell 上面
                        //
                                    PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: requestOptions) { (image, error) in
                        
                                        guard let image = image else { return }
                        
                                        self.delegate?.imageArray.append(image)
                                            }
                        if i == fetchResult.count - 1 {
                                DispatchQueue.main.async {
                                    self.delegate?.setupImage()
                                }
                                                                    }
                    }
                    
                    
//                    for i in 0..<fetchResult.count {
//
//                        let asset = fetchResult.object(at: i) as PHAsset
//
//                        PHImageManager.default().requestImageData(for: asset, options: PHImageRequestOptions(), resultHandler: { (imagedata, dataUTI, orientation, info) in
//
//                            if let info = info {
//
//                                if info.keys.contains(NSString(string: "PHImageFileURLKey")) {
//                                    if let path = info[NSString(string: "PHImageFileURLKey")] as? NSURL {
//
//                                        self.delegate?.imageURL.append(path as URL)
//
//                                        if i == fetchResult.count - 1 {
//                                            DispatchQueue.main.async {
//                                                self.delegate?.setupImage()
//                                            }
//                                        }
//                                    }
//                                }
//                              }
//                        })
//                    }
                    
                    
                }
                
                
                
        
            }
         
//            if fetchResult.count > 0 {
//                for i in 0..<fetchResult.count {
//
//                    guard let asset = fetchResult.object(at: i) as? PHAsset else { return }
////
//      //              存 URL >> 在用 kinfisher 去顯示在 collection view cell 上面
//
////                    imgManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: requestOptions) { (image, error) in
////
////                        guard let image = image else { return }
////
////                        self.delegate?.imageArray.append(image)
////
////                    }
//                }
//            } else {
//                print("You got no photos!")
//
//            }
        
    }
}
