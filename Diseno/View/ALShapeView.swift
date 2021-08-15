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
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let originTransform = transform
        transform = CGAffineTransform(rotationAngle: 0)
        drawWithShapeType()
        if stroke == true {
            shapeColor.setStroke()
            path.stroke()
        } else {
            shapeColor.setFill()
            path.fill()
        }
        transform = originTransform
    }
    
    func drawWithShapeType() {
        let type = ShapeAsset(rawValue: shapeType)
        switch type {
        case .circle:             createCircle()
        case .circleBorder:       createThinCircleBorder()
        case .square:             createSquare()
        case .rectangle:          createRectangle()
        case .equilateralTriangle:createEquilateralTriangle()
        case .triangle:           createTriangle()
        case .thinLine:           createThinLine()
        case .thickLine:          createThickLine()
        case .thickCircleBorder:  createThickCircleBorder()
        default: break
        }
    }
    
    func createSquare() {
        
        // Specify the point that the path should start get drawn.
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        
        path.addLine(to: CGPoint(x: 0.0, y: frame.size.height))
        path.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height))
        path.addLine(to: CGPoint(x: frame.size.width, y: 0.0))
        path.close()
    }
    
    func createRectangle() {
        
        // Specify the point that the path should start get drawn.
        path.move(to: CGPoint(x: 0.0, y: 20))
        
        path.addLine(to: CGPoint(x: frame.size.width, y: 20))
        path.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height-20))
        path.addLine(to: CGPoint(x: 0.0, y: frame.size.height-20))
        path.close()
    }
    
    func createCircle() {
       
//       let fillLayer = CAShapeLayer()
    
       path = UIBezierPath(ovalIn: CGRect(x: 0,
                                               y: 0,
                                               width: frame.size.height,
                                               height: frame.size.height))
        
//        fillLayer.path = path.cgPath
//        fillLayer.fillColor = UIColor.red.cgColor
//        layer.addSublayer(fillLayer)
    }
    
    func createThinCircleBorder() {
    
        path = UIBezierPath(ovalIn: CGRect(x: 10,
                                                y: 10,
                                                width: frame.size.height-20,
                                                height: frame.size.height-20))
        
         path.lineWidth = 3
    }
    
    func createThickCircleBorder() {
        
        path = UIBezierPath(ovalIn: CGRect(x: 19.5,
                                                y: 19.5,
                                                width: frame.size.height-39,
                                                height: frame.size.height-39))
        
        path.lineWidth = 39
    }
    
    //正三角形
    func createEquilateralTriangle() {

        path.move(to: CGPoint(x: frame.width/2, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: frame.size.height))
        path.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height))
        path.close()
    }
    
    func createTriangle() {

        path.move(to: CGPoint(x: frame.width, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: frame.size.height))
        path.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height))
        path.close()
    }
    
    func createThinLine() {
        
        path.move(to: CGPoint(x: 0.0, y: frame.height/2-1))
        path.addLine(to: CGPoint(x: frame.width, y: frame.size.height/2-1))
        path.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height/2+1))
        path.addLine(to: CGPoint(x: 0.0, y: frame.size.height/2+1))
        path.close()
    }
    
    func createThickLine() {
        
        path.move(to: CGPoint(x: 0.0, y: frame.height/2-3))
        path.addLine(to: CGPoint(x: frame.width, y: frame.size.height/2-3))
        path.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height/2+3))
        path.addLine(to: CGPoint(x: 0.0, y: frame.size.height/2+3))
        path.close()
    }
    
    // MARK: - Copy
    func makeACopyShape() -> ALShapeView {
        
        let newShape = ALShapeView()
        
        let originTransform = transform
        
        transform = CGAffineTransform(rotationAngle: 0)
        
        newShape.frame = frame
        
        newShape.bounds = bounds
        
        newShape.shapeType = shapeType
        
        newShape.alpha  = alpha
        
        if path.lineWidth > 1.0 {
          
            newShape.path.cgPath = path.cgPath.copy(strokingWithWidth: path.lineWidth,
                                                        lineCap: path.lineCapStyle,
                                                        lineJoin: path.lineJoinStyle,
                                                        miterLimit: path.miterLimit,
                                                        transform: transform)
            
        } else {
 
            newShape.drawWithShapeType()

        }
        
        let color = UIColor(cgColor: shapeColor.cgColor)
        
        newShape.shapeColor = color
        
        newShape.transform = originTransform
        
        transform = originTransform

        return newShape
        
    }
    
    func redrawWith(_ newColor: UIColor) {
        
        path = UIBezierPath()
        
        shapeColor = newColor
        
//        let originTransform = transform
//
//        transform = CGAffineTransform(rotationAngle: 0)
       
//        drawWithShapeType()

        setNeedsDisplay()
        
//        transform = originTransform
        
    }

    func mapping(_ shapeObject: Shape) {
        shapeObject.shapView = self
        shapeObject.shapeType = shapeType
        shapeObject.shapeColor = shapeColor
        shapeObject.stroke = stroke
        if let index = index {
            shapeObject.index = Int16(index)
        }
    }
}
