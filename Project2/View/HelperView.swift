//
//  HelperView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/18.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class HelperView: UIView {
    
    var leftHelper = UIView()
    var rightHelper = UIView()
    
    var rotateHelper = UIImageView()
    var positionHelper  =  UIImageView()
    var editingFrame = EditFrameView() {
        
        didSet {
            editingFrame.backgroundColor = UIColor.clear
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.masksToBounds = false
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupHelper()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupHelper()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        super.hitTest(point, with: event)
        
        super.hitTest(point, with: event)
        return overlapHitTest(point: point, withEvent: event)
    }
    
    func setupHelper() {
        
        self.addSubview(rotateHelper)
        self.addSubview(positionHelper)
        self.addSubview(editingFrame)
        
        rotateHelper.translatesAutoresizingMaskIntoConstraints = false
        positionHelper.translatesAutoresizingMaskIntoConstraints = false
        
        rotateHelper.centerXAnchor.constraint(equalTo:
            (editingFrame.centerXAnchor)).isActive = true
        rotateHelper.topAnchor.constraint(equalTo:
            (editingFrame.bottomAnchor), constant: 10).isActive = true
        rotateHelper.widthAnchor.constraint(equalToConstant: 20)
        rotateHelper.heightAnchor.constraint(equalToConstant: 20)
        
        positionHelper.centerYAnchor.constraint(equalTo:
            (editingFrame.centerYAnchor)).isActive = true
        positionHelper.leadingAnchor.constraint(equalTo:
            (editingFrame.trailingAnchor), constant: 10).isActive = true
        positionHelper.widthAnchor.constraint(equalToConstant: 20)
        positionHelper.heightAnchor.constraint(equalToConstant: 20)
        
        self.backgroundColor = UIColor.clear
        editingFrame.backgroundColor = UIColor.clear
        
        positionHelper.image = #imageLiteral(resourceName: "noun_navigate")
        rotateHelper.image = #imageLiteral(resourceName: "Icon_Rotate")
        
        positionHelper.backgroundColor = UIColor.white
        rotateHelper.backgroundColor = UIColor.white
        
        positionHelper.layer.cornerRadius = 10
        rotateHelper.layer.cornerRadius = 10
        
    }
    
    func resize(accordingTo view: UIView) {
        
        //Record the rotaion of the original view
        let originRotation =  view.transform
        
        //Transform the origin view
        view.transform = CGAffineTransform(rotationAngle: 0)
        
        self.frame = view.frame
        
        self.bounds = view.bounds
        
        self.transform = originRotation
        
        view.transform = originRotation
    }
    
    func setupSizeHelper() {
        
        leftHelper.addSubview(self)
        rightHelper.addSubview(self)
        
        
        
        
    }
   
}
