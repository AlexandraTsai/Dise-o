//
//  UIPangesture+Extension.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/8.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func angleBetween(pointA: CGPoint, pointB: CGPoint, origin: CGPoint) -> CGFloat {
        
        let oldDistance = CGPointDistance(from: pointA, to: origin)
        
        let newDistance = CGPointDistance(from: pointB, to: origin)
        
        let twoPointDistance = CGPointDistance(from: pointA,
                                               to: pointB)
        
        let numerator = oldDistance*oldDistance+newDistance*newDistance-twoPointDistance*twoPointDistance
        
        let denominator = 2*oldDistance*newDistance
        
        let newAngle = acos(numerator/denominator)
        
        return newAngle
        
    }
    
    // swiftlint:disable identifier_name
    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    // swiftlint:enable identifier_name

    func isClockwise(from oldPoint: CGPoint,
                     to newPoint: CGPoint,
                     center: CGPoint) -> Bool {
        
        let oldC = CGPointDistance(from: oldPoint, to: CGPoint(x: center.x, y: center.y+10))
        
        let newC = CGPointDistance(from: newPoint, to: CGPoint(x: center.x, y: center.y+10))
        
        let distance = CGPointDistance(from: oldPoint, to: center)
        
        let distance2 = CGPointDistance(from: newPoint, to: center)
        
        let oldAngle = acos((distance*distance+10*10-oldC*oldC)/(2*distance*10))
        
        let newAngle = acos((distance2*distance2+10*10-newC*newC)/(2*distance2*10))
        
        switch oldPoint.x - center.x {
            
        //Quadrant one & four
        case let value where value > 0 :
            
            if newAngle < oldAngle { return true } else { return false }
            
        case let value where value == 0 :
            
            if oldPoint.y > center.y {
                
                if newPoint.x > oldPoint.x { return true } else { return false }
                
            } else {
                
                if newPoint.x < oldPoint.x { return true } else { return false }
            }
            
        //Quadrant two & three
        default:
            
            if oldAngle < newAngle { return true } else { return false }
        }
        
    }

    func movePoint(target: CGPoint, aroundOrigin origin: CGPoint, byDegree: CGFloat) -> CGPoint {
        
        let distanceX = target.x - origin.x
        let distanceY = target.y - origin.y
        
        let radius = sqrt(distanceX*distanceX+distanceY*distanceY)
        
        let azimuth = atan2(distanceY, distanceX)
        let newAzimuth = azimuth + byDegree*CGFloat.pi/180.0
        
        let newX = origin.x + radius*cos(newAzimuth)
        let newY = origin.y + radius*sin(newAzimuth)
        
        return CGPoint(x: newX, y: newY)
        
    }
    
}
