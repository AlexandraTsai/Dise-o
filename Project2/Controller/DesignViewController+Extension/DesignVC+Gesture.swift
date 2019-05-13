//
//  DesignVC+Gesture.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/13.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

extension DesignViewController {
    
    func addAllGesture(to newView: UIView) {
        
        newView.isUserInteractionEnabled = true
        
        //Handle label to tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        newView.addGestureRecognizer(tap)
        
    }
    
    func addGesture(to view: UIView, action: Selector) {
        
        let gesture = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(gesture)
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        guard let tappedView = sender.view else { return }
        
        guard (tappedView as? ALImageView) != nil else {
            
            goToEditingVC(with: tappedView, navigationBarForImage: false)
            return
        }
        
        goToEditingVC(with: tappedView, navigationBarForImage: true)
        
    }
    
    @objc func designViewClicked(_ sender: UITapGestureRecognizer) {
        
        addElementView.isHidden = true
        hintView.isHidden = !hintView.isHidden
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            
            self?.addButton.transform = CGAffineTransform(rotationAngle: 0)
        }
        
        if designView.image == nil {
            
            addShapeContainerView.isHidden = true
            
            delegate?.noImageMode()
            
        } else {
            
            delegate?.editImageMode()
            
        }
        
    }
    
//    @objc func handleRotation(sender: UIRotationGestureRecognizer) {
//        
//        guard  sender.view != nil else {
//            return
//            
//        }
//        
//        if sender.state == .began || sender.state == .changed {
//            
//            guard let rotateValue = sender.view?.transform.rotated(by: sender.rotation) else {
//                return
//            }
//            
//            sender.view?.transform = rotateValue
//            sender.rotation = 0
//            
//        }
//        
//    }
//    
//    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
//        
//        guard  sender.view != nil else {
//            return
//            
//        }
//        
//        if sender.state == .began || sender.state == .changed {
//            
//            guard let transform = sender.view?.transform.scaledBy(x: sender.scale*0/5,
//                                                                  y: sender.scale*0/5) else { return }
//            
//            sender.view?.transform = transform
//            sender.scale = 1.0
//            
//        }
//    }
//    
//    @objc func handleDragged( _ gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: self.view)
//        let view = gesture.view
//        
//        guard let xCenter = view?.center.x, let yCenter = view?.center.y else { return }
//        
//        view?.center = CGPoint(x: xCenter+translation.x, y: yCenter+translation.y)
//        gesture.setTranslation(CGPoint.zero, in: view)
//        
//    }
    
}
