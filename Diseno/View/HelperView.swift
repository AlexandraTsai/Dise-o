//
//  HelperView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/18.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class HelperView: UIView {
   
    let leftHelper = SizeHelperView()
    let rightHelper = SizeHelperView()
    let topHelper = SizeHelperView()
    let bottomHelper = SizeHelperView()
    
    let leftTopHelper = CornerHelperView()
    let leftBottomHelper = CornerHelperView()
    let rightTopHelper = CornerHelperView()
    let rightBottomHelper = CornerHelperView()
    
    let rotateHelper = RotateHelperView()
    let positionHelper  =  UIImageView()
    var editingFrame = EditFrameView()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.masksToBounds = false
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupHelper()
        setupSizeHelper()
        enableUserInteractive()
        setupCornerHelper()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupHelper()
        setupSizeHelper()
        enableUserInteractive()
        setupCornerHelper()
        
    }
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        
        super.draw(layer, in: ctx)
        
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
        
        leftHelper.direct = Direction.left
        rightHelper.direct = Direction.right
        topHelper.direct = Direction.top
        bottomHelper.direct = Direction.bottom
        
    }
    
    func setupCornerHelper() {
        
        self.addSubview(leftTopHelper)
        self.addSubview(leftBottomHelper)
        self.addSubview(rightTopHelper)
        self.addSubview(rightBottomHelper)
        
        leftTopHelper.translatesAutoresizingMaskIntoConstraints = false
        
        leftTopHelper.centerXAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        leftTopHelper.centerYAnchor.constraint(equalTo: self.topAnchor).isActive = true
        leftTopHelper.widthAnchor.constraint(equalToConstant: 10).isActive = true
        leftTopHelper.heightAnchor.constraint(equalToConstant: 10).isActive = true

        rightTopHelper.translatesAutoresizingMaskIntoConstraints = false
        
        rightTopHelper.centerXAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        rightTopHelper.centerYAnchor.constraint(equalTo: self.topAnchor).isActive = true
        rightTopHelper.widthAnchor.constraint(equalTo: leftTopHelper.widthAnchor).isActive = true
        rightTopHelper.heightAnchor.constraint(equalTo: leftTopHelper.heightAnchor).isActive = true

        leftBottomHelper.translatesAutoresizingMaskIntoConstraints = false
        
        leftBottomHelper.centerXAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        leftBottomHelper.centerYAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        leftBottomHelper.widthAnchor.constraint(equalTo: leftTopHelper.widthAnchor).isActive = true
        leftBottomHelper.heightAnchor.constraint(equalTo: leftTopHelper.heightAnchor).isActive = true

        rightBottomHelper.translatesAutoresizingMaskIntoConstraints = false
        
        rightBottomHelper.centerXAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        rightBottomHelper.centerYAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        rightBottomHelper.widthAnchor.constraint(equalTo: leftTopHelper.widthAnchor).isActive = true
        rightBottomHelper.heightAnchor.constraint(equalTo: leftTopHelper.heightAnchor).isActive = true

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
    
    func hideAllHelper() {
        
        rightHelper.alpha = 0
        leftHelper.alpha = 0
        topHelper.alpha = 0
        bottomHelper.alpha = 0
        
        leftTopHelper.alpha = 0
        leftBottomHelper.alpha = 0
        rightTopHelper.alpha = 0
        rightBottomHelper.alpha = 0
    }
    
    func showAllHelper() {

        rightHelper.alpha = 1
        leftHelper.alpha = 1
        topHelper.alpha = 1
        bottomHelper.alpha = 1
        
        leftTopHelper.alpha = 1
        leftBottomHelper.alpha = 1
        rightTopHelper.alpha = 1
        rightBottomHelper.alpha = 1
    }
    
    func enableUserInteractive() {
        
        self.isUserInteractionEnabled = true
        
        for subView in self.subviews {
            
            subView.isUserInteractionEnabled = true
        }
        
    }
    
    func rotateHelperAddGesture(target: Any?, action: Selector) {
        
        addPanGesture(to: rotateHelper, target: target, action: action)
        
    }
    
    func positionHelperAddGesture(target: Any?, action: Selector) {
        
        addPanGesture(to: positionHelper, target: target, action: action)
        
    }
    
    func sizeHelperAddGesture(target: Any?, action: Selector) {
        
        addPanGesture(to: topHelper, target: target, action: action)
        addPanGesture(to: leftHelper, target: target, action: action)
        addPanGesture(to: bottomHelper, target: target, action: action)
        addPanGesture(to: rightHelper, target: target, action: action)
        
    }
    
    func cornerHelperAddGesture(target: Any?, action: Selector) {
        
        addPanGesture(to: leftTopHelper, target: target, action: action)
        addPanGesture(to: rightTopHelper, target: target, action: action)
        addPanGesture(to: leftBottomHelper, target: target, action: action)
        addPanGesture(to: rightBottomHelper, target: target, action: action)

    }
    
    func addPanGesture(to view: UIView, target: Any?, action: Selector) {
        
        let pan = UIPanGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(pan)
        
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
        
        resizeEditingFrame(accordingTo: view)
    }
    
    func resizeEditingFrame(accordingTo view: UIView) {
        
        let center = view.center
        
        if let rect = self.superview?.convert(center, to: self) {
            
            editingFrame.center = rect
            editingFrame.bounds = view.bounds
        }
        
        layoutIfNeeded()
        
    }
    
    func showHelper(after gesture: UIGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizer.State.ended {
            
            self.showAllHelper()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.hideAllHelper()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.showAllHelper()
    }

}
