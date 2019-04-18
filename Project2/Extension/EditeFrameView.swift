//
//  EditeFrameView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/18.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class EditFrameView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let context = UIGraphicsGetCurrentContext()
        
        ///Shadow Declarations
        let shadow = UIColor.black
        let shadowOffSet = CGSize(width: 0, height: 0)
        let shadowBlurRadius: CGFloat = 5
        
        ///Bezier Drawing
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        bezierPath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        bezierPath.addLine(to: CGPoint(x: 0, y: self.bounds.height))
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        context?.saveGState()
        
        context?.setShadow(offset: shadowOffSet, blur: shadowBlurRadius, color: shadow.cgColor)
        UIColor.white.setStroke()
        bezierPath.lineWidth = 1
        bezierPath.stroke()
        context?.restoreGState()
        
    }
}
