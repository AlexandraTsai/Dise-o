//
//  SizeHelperView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/28.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class SizeHelperView: UIView {
    
    var direct: Direction?
    
    var hitInsets: UIEdgeInsets = UIEdgeInsets(top: -10,
                                              left: -10,
                                              bottom: -10,
                                              right: -10)
  
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        // Generate the new hit area by adding the hitInsets:
        let newRect = CGRect(x: 0 + hitInsets.left,
                             y: 0 + hitInsets.top,
                             width: self.frame.size.width - hitInsets.left - hitInsets.right,
                             height: self.frame.size.height - hitInsets.top - hitInsets.bottom)
        
        // Check if the point is within the new hit area:
        return newRect.contains(point)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupShadow()
    }
    
    func setupShadow() {
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 4
        
        //Shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
    
    }
    
}
