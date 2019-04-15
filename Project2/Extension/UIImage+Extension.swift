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
    case Icon_uTurn_right
    case Icon_Download

    case Icon_Eye_Dropper

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
