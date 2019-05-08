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
    
    func makeACopy(from originView: ALImageView) {
        
        let originRotation =  originView.transform
        
        //Transform the origin image view
        originView.transform = CGAffineTransform(rotationAngle: 0)
        
        self.frame = originView.frame
        
        self.transform = originRotation
        self.image = originView.image
        self.alpha = originView.alpha
        
        originView.transform = originRotation
        
        self.filterName = originView.filterName
        
        self.originImage = originView.originImage
        
        self.imageFileName = originView.imageFileName
        
    }
    
}
