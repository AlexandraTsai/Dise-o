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

    
}
