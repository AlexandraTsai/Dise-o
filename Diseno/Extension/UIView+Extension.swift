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
        
        self.bounds = CGRect(x: 0,
                             y: 0,
                             width: originView.bounds.width*forSize,
                             height: originView.bounds.height*forSize)
        
        self.center = originView.center
        
        self.transform = originRotation
        
        originView.transform = originRotation
    }
    
    func overlapHitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
       
        if !self.isUserInteractionEnabled
            || self.isHidden
            || self.alpha == 0 {
            
            return nil
        }
        
        // If touch is inside self, self will be considered as potential result.
        var hitView: UIView? = self
        if !self.point(inside: point, with: event) {
            
            if self.clipsToBounds {
                return nil
            } else {
                hitView = nil
            }
        }
        
        // Check recursively all subviews for hit. If any, return it.
        for subview in self.subviews.reversed() {
            
            let insideSubview = self.convert(point, to: subview)
          
            if let sview = subview.overlapHitTest(point: insideSubview, withEvent: event) {
                
                return sview
            }
        }
        
        // Else return self or nil depending on result from step 2.
        return hitView
    }
    
}
