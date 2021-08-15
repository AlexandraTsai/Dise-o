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

    func mapping(_ design: Design) {
        design.frame = frame as NSObject
        design.designName = designName
        design.filter = filterName?.rawValue

        if let screenshot = screenshotName {
            design.screenshot = screenshot
        }
        design.backgroundColor = backgroundColor
        design.backgroundImage = imageFileName

        design.images = NSSet(array:
            subImages.map {
                $0.mapping(Image(context: StorageManager.shared.viewContext))
            }
        )

        design.texts = NSSet(array:
            subTexts.map {
                $0.mapping(Text(context: StorageManager.shared.viewContext))
            }
        )

        design.shapes = NSSet(array:
            subShapes.map {
                $0.mapping(Shape(context: StorageManager.shared.viewContext))
            }
        )
    }
}
