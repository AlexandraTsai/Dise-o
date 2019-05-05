//
//  UIImage+Extension.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/3.
//  Copyright © 2019年 蔡佳宣. All rights reserved.

import UIKit

enum ImageAsset: String {

    case back

    // swiftlint:disable identifier_name
    //Image Edit Page
    case Icon_down
    case Icon_up
    case Icon_TrashCan
    case Icon_Share
    case Icon_Crop
    case Icon_Rotate
    case Icon_Copy

    //Text Edit
    case Icon_AlignCenter
    case Icon_AlignLeft
    case Icon_AlignRight

    //Home Page
    case Icon_image
    case Icon_text
    case Icon_shape
    case Icon_sortDown

    case Icon_profile
    case Icon_HomePage
    case Icon_uTurn_right
    case Icon_Download

    case Icon_Eye_Dropper
    
    case Icon_show_more
    
    case Icon_add_button
    
    case Icon_color
    
    case Icon_transparency
    
    case Icon_filter
    
    case Icon_Circle
    
    case Icon_AppName
    
    var imageTemplate: UIImage {
        
        let origImage = UIImage(named: self.rawValue)
        
        guard let tintedImage =
            
            origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            
            else { return UIImage()}
        
        return tintedImage
        
    }

}
// swiftlint:enable identifier_name

extension UIImage {

    static func asset(_ asset: ImageAsset) -> UIImage? {

        return UIImage(named: asset.rawValue)
    }

}

enum ShapeAsset: String, CaseIterable {
    
    case circle
    case equilateralTriangle
    case triangle
    case square
    case rectangle
    
    //Line
    case thinLine
    case thickLine
    
    //Only border
    case circleBorder
    case thickCircleBorder
    
    func shapeBorderOnly() -> Bool {
        
        switch self {
        case .circleBorder, .thickCircleBorder:
            return true
        default:
            return false
        }
    }

}

extension UIImage {
    
    func addFilter(filter : FilterType) -> UIImage {
        
        let filter = CIFilter(name: filter.rawValue)
        
        // convert UIImage to CIImage and set as input
        let ciInput = CIImage(image: self)
        
        filter?.setValue(ciInput, forKey: kCIInputImageKey)
        
        // get output CIImage, render as CGImage first to retain proper UIImage scale
        guard let ciOutput = filter?.outputImage else { return self }
        
        let ciContext = CIContext()
        
        guard let cgImage = ciContext.createCGImage(ciOutput, from: ciOutput.extent)  else { return self }
        
        //Return the image
        return UIImage(cgImage: cgImage)
    }
}
