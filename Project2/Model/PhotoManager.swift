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
 
}

class PhotoManager {
    
    weak var delegate: PhotoManagerDelegate?
    
    func grabPhoto() {
        
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
            
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count {
                    
                    guard let asset = fetchResult.object(at: i) as? PHAsset else { return }
                    
                    imgManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: requestOptions) { (image, error) in
                        
                        guard let image = image else { return }
                        
                        self.delegate?.imageArray.append(image)
                        
                    }
                }
            } else {
                print("You got no photos!")
               
            }
        }
    }
}
