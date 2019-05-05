//
//  ALDesignView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/20.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class ALDesignView: UIImageView {
    
    var designName: String = ""
    
    var filterName: FilterType?
    
    var createTime: Int64?
    
    var subImages = [ALImageView]()
    
    var subTexts = [ALTextView]()
    
    var subShapes = [ALShapeView]()
    
    var imageFileName: String?
    
    var screenshotName: String?
    
    func takeScreenshot() -> UIImage {
      
        UIGraphicsBeginImageContextWithOptions(self.bounds.size,
                                               false,
                                               UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let screenshotImage = image {
            
            return screenshotImage
            
        }
        return UIImage()
    }
  
}
