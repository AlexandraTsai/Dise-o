//
//  ALRotationGestureRecognizer.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/12.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit.UIGestureRecognizer

class ALRotationGestureRecognizer: UIPanGestureRecognizer {
    
    private(set) var touchAngle: CGFloat = 0
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        maximumNumberOfTouches = 1
        minimumNumberOfTouches = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        updateAngle(with: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        updateAngle(with: touches)
    }
    
    private func updateAngle(with touches: Set<UITouch>) {
        
        guard let touch = touches.first,
            let view = view else { return }
        
        let touchPoint = touch.location(in: view)
        touchAngle = angle(for: touchPoint, in: view)
    }
    
    private func angle(for point: CGPoint, in view: UIView) -> CGFloat {
        
        let centerOffset = CGPoint(x: point.x - view.bounds.midX, y: point.y - view.bounds.midY)
        return atan2(centerOffset.y, centerOffset.x)
    }
    
}
