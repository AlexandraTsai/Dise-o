//
//  ALImageView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/21.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//
import UIKit

class ALImageView: UIImageView {
    var index: Int?
    var imageFileName: String?
    var filterName: FilterType?
    var originImage: UIImage?
    
    func makeACopy() -> ALImageView {
        let newView = ALImageView()
        let originRotation =  self.transform
        //Transform the origin image view
        self.transform = CGAffineTransform(rotationAngle: 0)
        newView.frame = self.frame
        newView.transform = originRotation
        newView.image = self.image
        newView.alpha = self.alpha
        
        self.transform = originRotation
        newView.filterName = self.filterName
        newView.originImage = self.originImage
        newView.imageFileName = self.imageFileName
        return newView
    }

    func mapping(_ imageObject: Image) {
        if let imageToSave = imageFileName {
            imageObject.image = imageToSave
        }
        if let filterName = filterName {
            imageObject.filter = filterName.rawValue
        }
        if let objectIndex = index {
            imageObject.index = Int16(objectIndex)
        }
        imageObject.alpha = alpha as NSObject
        imageObject.transform = transform as NSObject
        transform = CGAffineTransform(rotationAngle: 0)
        imageObject.frame = frame as NSObject
    }
}
