//
//  RotateHelperView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/3.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class RotateHelperView: UIImageView {
    
    var hitInsets: UIEdgeInsets = UIEdgeInsets(top: -5,
                                              left: -5,
                                              bottom: -5,
                                              right: -5)
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        // Generate the new hit area by adding the hitInsets:
        let newRect = CGRect(x: 0 + hitInsets.left,
                             y: 0 + hitInsets.top,
                             width: self.frame.size.width - hitInsets.left - hitInsets.right,
                             height: self.frame.size.height - hitInsets.top - hitInsets.bottom)
        
        // Check if the point is within the new hit area:
        return newRect.contains(point)
    }
    
    func increaseHitInset() {
        
        if let superHeight = self.superview?.bounds.height,
            let superWeight = self.superview?.bounds.width {
            
            hitInsets = UIEdgeInsets(top: -self.frame.origin.y,
                                     left: -self.frame.origin.x,
                                     bottom: -(superHeight-self.frame.origin.y-self.bounds.height),
                                     right: -(superWeight-self.frame.origin.y-self.bounds.width))
            
        }
        
    }

    func decreaseHitInset() {
        
        hitInsets = UIEdgeInsets(top: -5,
                                 left: -5,
                                 bottom: -5,
                                 right: -5)
        
    }
}
