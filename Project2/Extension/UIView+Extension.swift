//
//  UIView+Extension.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/12.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

extension UIView {
    
    func makeACopy(from originView: UIView) {
        
        //Record the rotaion of the original image view
        let originRotation =  originView.transform

        //Transform the origin image view
        originView.transform = CGAffineTransform(rotationAngle: 0)

        self.frame = originView.frame

        self.transform = originRotation

        originView.transform = originRotation
    }
    
    func makeEqualCenterView(from originView: UIView, forSize: CGFloat) {
        
        //Record the rotaion of the original image view
        let originRotation =  originView.transform
        
        //Transform the origin image view
        originView.transform = CGAffineTransform(rotationAngle: 0)
        
        self.bounds = CGRect(x: 0, y: 0, width: originView.bounds.width*forSize, height: originView.bounds.height*forSize)
        self.center = originView.center
        
        self.transform = originRotation
        
        originView.transform = originRotation
    }
}
