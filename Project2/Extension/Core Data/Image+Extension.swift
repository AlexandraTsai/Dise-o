//
//  Image+Extension.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/24.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import CoreData
import UIKit

extension Image {
    
    func transformImage(for designView: ALDesignView) {
        
        guard let frame = self.frame as? CGRect,
            let fileName = self.image,
            let transform = self.transform as? CGAffineTransform else { return }
        
        let imageView = ALImageView()
        
        imageView.frame = frame
        
        imageView.transform = transform
        
        let image = loadImageFromDiskWith(fileName: fileName)
        
        if let filter = self.filter {
            
            for type in FilterType.allCases {
                
                if type.rawValue == filter {
                    
                    imageView.image = image?.addFilter(filter: type)
                    
                    imageView.filterName = type
                    
                }
            }
            
        } else {
            
            imageView.image = image
            
        }
        
        imageView.originImage = image
        
        imageView.imageFileName = fileName
        
        imageView.index = Int(self.index)
        
        designView.subImages.append(imageView)
        
        designView.addSubview(imageView)
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory,
                                                        userDomainMask,
                                                        true)
        
        if let dirPath = paths.first {
            
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            
            let image = UIImage(contentsOfFile: imageUrl.path)
            
            return image
            
        }
        
        return nil
    }
}
