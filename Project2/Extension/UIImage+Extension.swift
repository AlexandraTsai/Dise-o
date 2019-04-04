//
//  UIImage+Extension.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/3.
//  Copyright © 2019年 蔡佳宣. All rights reserved.

import UIKit
    
enum ImageAsset: String {
    
    case Icon_back
    
    //Image Edit Page
    case Icon_down
    case Icon_up
    case Icon_TrashCan
    case Icon_Share
    case Icon_Crop
    case Icon_Rotate
    case Icon_Copy
    
    //Home Page
    case Icon_image
    case Icon_text
    case Icon_shape
   
    case Icon_profile
    case Icon_uTurn_right
    case Icon_Download
    
    case Icon_Eye_Dropper
    
}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
    
}
