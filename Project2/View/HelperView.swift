//
//  HelperView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/18.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class HelperView: UIView {
    
    var rotateHelper = UIImageView()
    var positionHelper  =  UIImageView()
    var editingFrame = EditFrameView() {
        
        didSet {
            editingFrame.backgroundColor = UIColor.clear
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.masksToBounds = false
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        super.hitTest(point, with: event)
        
        super.hitTest(point, with: event)
        return overlapHitTest(point: point, withEvent: event)
    }
}
