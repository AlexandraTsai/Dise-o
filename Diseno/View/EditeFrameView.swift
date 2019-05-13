//
//  EditeFrameView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/18.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class EditFrameView: UIView {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupShadow()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setupShadow()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let context = UIGraphicsGetCurrentContext()
        
        ///Shadow Declarations
        let shadow = UIColor.black.withAlphaComponent(0.8)
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
    
    func setupShadow() {
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
        
    }
}
