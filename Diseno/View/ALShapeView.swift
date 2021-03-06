//
//  shapeView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/14.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class ALShapeView: UIView {
    
    var index: Int?

    var path = UIBezierPath()
    var shapeType: String = ""
    
    var hue: CGFloat = 0.0
    var shapeColor: UIColor = UIColor.init(red: 221/255, green: 221/255, blue: 221/255, alpha: 1)
    var stroke: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let originTransform = self.transform
        
        self.transform = CGAffineTransform(rotationAngle: 0)
        
        drawWithShapeType()
        
        if stroke == true {

            shapeColor.setStroke()
            path.stroke()

        } else {

            shapeColor.setFill()
            path.fill()
        }
        
        self.transform = originTransform
    
    }
    
    func drawWithShapeType() {
        switch shapeType {
        case ShapeAsset.circle.rawValue:
            self.createCircle()
        case ShapeAsset.circleBorder.rawValue:
            self.createThinCircleBorder()
        case ShapeAsset.square.rawValue:
            self.createSquare()
        case ShapeAsset.rectangle.rawValue:
            self.createRectangle()
        case ShapeAsset.equilateralTriangle.rawValue:
            self.createEquilateralTriangle()
        case ShapeAsset.triangle.rawValue:
            self.createTriangle()
        case ShapeAsset.thinLine.rawValue:
            self.createThinLine()
        case ShapeAsset.thickLine.rawValue:
            self.createThickLine()
        case ShapeAsset.thickCircleBorder.rawValue:
            self.createThickCircleBorder()
    
        default:
            break
        }
    }
    
    func createSquare() {
        
        // Specify the point that the path should start get drawn.
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0.0))
        path.close()
    }
    
    func createRectangle() {
        
        // Specify the point that the path should start get drawn.
        path.move(to: CGPoint(x: 0.0, y: 20))
        
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 20))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height-20))
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height-20))
        path.close()
    }
    
    func createCircle() {
       
//       let fillLayer = CAShapeLayer()
    
       self.path = UIBezierPath(ovalIn: CGRect(x: 0,
                                               y: 0,
                                               width: self.frame.size.height,
                                               height: self.frame.size.height))
        
//        fillLayer.path = self.path.cgPath
//        fillLayer.fillColor = UIColor.red.cgColor
//        self.layer.addSublayer(fillLayer)
    }
    
    func createThinCircleBorder() {
    
        self.path = UIBezierPath(ovalIn: CGRect(x: 10,
                                                y: 10,
                                                width: self.frame.size.height-20,
                                                height: self.frame.size.height-20))
        
         path.lineWidth = 3
    }
    
    func createThickCircleBorder() {
        
        self.path = UIBezierPath(ovalIn: CGRect(x: 19.5,
                                                y: 19.5,
                                                width: self.frame.size.height-39,
                                                height: self.frame.size.height-39))
        
        path.lineWidth = 39
    }
    
    //正三角形
    func createEquilateralTriangle() {

        path.move(to: CGPoint(x: self.frame.width/2, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        path.close()
    }
    
    func createTriangle() {

        path.move(to: CGPoint(x: self.frame.width, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        path.close()
    }
    
    func createThinLine() {
        
        path.move(to: CGPoint(x: 0.0, y: self.frame.height/2-1))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.size.height/2-1))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height/2+1))
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height/2+1))
        path.close()
    }
    
    func createThickLine() {
        
        path.move(to: CGPoint(x: 0.0, y: self.frame.height/2-3))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.size.height/2-3))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height/2+3))
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height/2+3))
        path.close()
    }
    
    // MARK: - Copy
    func makeACopyShape() -> ALShapeView {
        
        let newShape = ALShapeView()
        
        let originTransform = self.transform
        
        self.transform = CGAffineTransform(rotationAngle: 0)
        
        newShape.frame = self.frame
        
        newShape.bounds = self.bounds
        
        newShape.shapeType = self.shapeType
        
        newShape.alpha  = self.alpha
        
        if self.path.lineWidth > 1.0 {
          
            newShape.path.cgPath = self.path.cgPath.copy(strokingWithWidth: self.path.lineWidth,
                                                        lineCap: self.path.lineCapStyle,
                                                        lineJoin: self.path.lineJoinStyle,
                                                        miterLimit: self.path.miterLimit,
                                                        transform: self.transform)
            
        } else {
 
            newShape.drawWithShapeType()

        }
        
        let color = UIColor(cgColor: self.shapeColor.cgColor)
        
        newShape.shapeColor = color
        
        newShape.transform = originTransform
        
        self.transform = originTransform

        return newShape
        
    }
    
    func redrawWith(_ newColor: UIColor) {
        
        self.path = UIBezierPath()
        
        self.shapeColor = newColor
        
//        let originTransform = self.transform
//
//        self.transform = CGAffineTransform(rotationAngle: 0)
       
//        self.drawWithShapeType()

        self.setNeedsDisplay()
        
//        self.transform = originTransform
        
    }
}
