//
//  EditeFrameView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/18.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class EditFrameView: UIView {
    
    let verticalLine = UIView()
    let horizontalLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
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
    
    func setupAlignment() {
        
        self.addSubview(horizontalLine)
        self.addSubview(verticalLine)
        
        horizontalLine.translatesAutoresizingMaskIntoConstraints = false
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        horizontalLine.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true
        horizontalLine.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        horizontalLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        verticalLine.heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
        verticalLine.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalLine.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        verticalLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        verticalLine.backgroundColor = UIColor.red
        horizontalLine.backgroundColor = UIColor.red
    }
    
    func showAlignment() {
        
        horizontalLine.alpha = 1
        verticalLine.alpha = 1
    }
    
    func hideAlignment() {
        
        horizontalLine.alpha = 0
        verticalLine.alpha = 0
        
    }
}
