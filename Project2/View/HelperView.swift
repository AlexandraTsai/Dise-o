//
//  HelperView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/18.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class HelperView: UIView {
    
    var leftHelper = SizeHelperView()
    var rightHelper = SizeHelperView()
    var topHelper = SizeHelperView()
    var bottomHelper = SizeHelperView()
    
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
        setupSizeHelper()
        enableUserInteractive()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupHelper()
        setupSizeHelper()
        enableUserInteractive()
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
        
        editingFrame.translatesAutoresizingMaskIntoConstraints = false
        rotateHelper.translatesAutoresizingMaskIntoConstraints = false
        positionHelper.translatesAutoresizingMaskIntoConstraints = false
        
        editingFrame.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        editingFrame.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        editingFrame.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        editingFrame.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
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
        
        self.addSubview(leftHelper)
        self.addSubview(rightHelper)
        self.addSubview(topHelper)
        self.addSubview(bottomHelper)
        
        //Layout
        leftHelper.translatesAutoresizingMaskIntoConstraints = false
        rightHelper.translatesAutoresizingMaskIntoConstraints = false
        topHelper.translatesAutoresizingMaskIntoConstraints = false
        bottomHelper.translatesAutoresizingMaskIntoConstraints = false
        
        leftHelper.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        leftHelper.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        leftHelper.widthAnchor.constraint(equalToConstant: 4).isActive = true
        leftHelper.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        rightHelper.centerXAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        rightHelper.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rightHelper.widthAnchor.constraint(equalTo: leftHelper.widthAnchor).isActive = true
        rightHelper.heightAnchor.constraint(equalTo: leftHelper.heightAnchor).isActive = true
        
        topHelper.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        topHelper.centerYAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topHelper.widthAnchor.constraint(equalToConstant: 20).isActive = true
        topHelper.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        bottomHelper.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        bottomHelper.centerYAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomHelper.widthAnchor.constraint(equalTo: topHelper.widthAnchor).isActive = true
        bottomHelper.heightAnchor.constraint(equalTo: topHelper.heightAnchor).isActive = true
        
        setupShadow()
        
    }
    
    func setupShadow() {
        
        leftHelper.backgroundColor = UIColor.white
        leftHelper.layer.cornerRadius = 4
        
        rightHelper.backgroundColor = UIColor.white
        rightHelper.layer.cornerRadius = 4
        
        topHelper.backgroundColor = UIColor.white
        topHelper.layer.cornerRadius = 4
        
        bottomHelper.backgroundColor = UIColor.white
        bottomHelper.layer.cornerRadius = 4
        
        //Shadow
        leftHelper.layer.shadowColor = UIColor.black.cgColor
        leftHelper.layer.shadowOffset = CGSize(width: 0, height: 0)
        leftHelper.layer.shadowRadius = 3
        leftHelper.layer.shadowOpacity = 1
        
        rightHelper.layer.shadowColor = UIColor.black.cgColor
        rightHelper.layer.shadowOffset = CGSize(width: 0, height: 0)
        rightHelper.layer.shadowRadius = 3
        rightHelper.layer.shadowOpacity = 1
        
        topHelper.layer.shadowColor = UIColor.black.cgColor
        topHelper.layer.shadowOffset = CGSize(width: 0, height: 0)
        topHelper.layer.shadowRadius = 3
        topHelper.layer.shadowOpacity = 1
        
        bottomHelper.layer.shadowColor = UIColor.black.cgColor
        bottomHelper.layer.shadowOffset = CGSize(width: 0, height: 0)
        bottomHelper.layer.shadowRadius = 3
        bottomHelper.layer.shadowOpacity = 1
        
        editingFrame.layer.shadowColor = UIColor.black.cgColor
        editingFrame.layer.shadowOffset = CGSize(width: 0, height: 0)
        editingFrame.layer.shadowRadius = 3
        editingFrame.layer.shadowOpacity = 1
    }
    
    func enableUserInteractive() {
        
        rightHelper.isUserInteractionEnabled = true
        leftHelper.isUserInteractionEnabled = true
        
    }
   
    func withoutResizeHelper() {
        
        rightHelper.isHidden = true
        leftHelper.isHidden = true
        topHelper.isHidden = true
        bottomHelper.isHidden = true
        
    }
    
    func withResizeHelper() {
        
        rightHelper.isHidden = false
        leftHelper.isHidden = false
        topHelper.isHidden = false
        bottomHelper.isHidden = false
    }
    
    func withWidthHelper() {
        
        rightHelper.isHidden = false
        leftHelper.isHidden = false
        topHelper.isHidden = true
        bottomHelper.isHidden = true
    }
   
}
