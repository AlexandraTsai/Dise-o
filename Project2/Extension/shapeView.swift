//
//  shapeView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/14.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class ShapeView: UIView {

    var path = UIBezierPath()
    var shapeType: String = ""
    var defaultColor: UIColor = UIColor.white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        switch shapeType {
        case ShapeAsset.circle.rawValue:
            self.createCircle()
        case ShapeAsset.rectangle.rawValue:
            self.createRectangle()
        default:
            break
        }
        
        defaultColor.setFill()
        path.fill()
    
    }
    
    func createRectangle() {
        
        path = UIBezierPath()
        
        // Specify the point that the path should start get drawn.
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0.0))
        path.close()
    }
    
    func createCircle() {
        self.path = UIBezierPath(ovalIn: CGRect(x: self.frame.size.width/2-self.frame.size.height/2,
                                                y: 0.0,
                                                width: self.frame.size.height,
                                                height: self.frame.size.height))
    }
}
