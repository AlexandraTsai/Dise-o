//
//  EditingViewController+Extension.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/13.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

//Setup Gesture
extension EditingViewController {
    
    func addAllGesture(to helperView: UIView) {
        
        //Enable textView to rotate
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(sender:)))
        helperView.addGestureRecognizer(rotate)
        
        //Enable to move textView
        let move = UIPanGestureRecognizer(target: self, action: #selector(handleDragged(_ :)))
        helperView.addGestureRecognizer(move)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
        helperView.addGestureRecognizer(pinch)
        
        //Enable to edit textView
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        helperView.addGestureRecognizer(doubleTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHelperView(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        helperView.addGestureRecognizer(tap)
        
    }
    
    func addTapGesture(to newView: UIView) {
        
        newView.isUserInteractionEnabled = true
        
        //Handle to tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        newView.addGestureRecognizer(tap)
    }
    
    func addCircleGesture(to rotateView: UIView) {
        
        rotateView.isUserInteractionEnabled = true
        
        //Handle to tapped
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleCircleGesture(sender:)))
        rotateView.addGestureRecognizer(pan)
    }
    
    func addGestureToAllSubview() {
        
        guard designView.subviews.count > 0 else { return }
        
        for count in 0...designView.subviews.count-1
            
            where designView.subviews[count] != helperView {
                
                addTapGesture(to: designView.subviews[count])
                
        }
        
    }
    
    @objc func handleDoubleTap(sender: UITapGestureRecognizer) {
        
        guard let textView = editingView as? ALTextView else { return }
        
        textView.addDoneButtonOnKeyboard()
        
        textView.becomeFirstResponder()
        
        helperView.showHelper(after: sender)
        
    }
    
    @objc func tapHelperView(sender: UITapGestureRecognizer) {
        
        if let textView = editingView as? ALTextView {
            
            textView.addDoneButtonOnKeyboard()
            
            textView.becomeFirstResponder()
            
        } else {
            
            helperView.alpha = 0
            
            UIView.animate(withDuration: 0.2) {  [weak self] in
                
                self?.helperView.alpha = 1
                
                self?.helperView.showHelper(after: sender)
            }
            
        }
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        helperView.removeFromSuperview()
        
        editingView = sender.view
        
        helperView.showHelper(after: sender)
        
    }
    
    @objc func handleRotation(sender: UIRotationGestureRecognizer) {
        
        guard  sender.view != nil else {
            return
            
        }
        
        if sender.state == .began || sender.state == .changed {
            
            guard let rotateValue = sender.view?.transform.rotated(by: sender.rotation) else { return }
            
            sender.view?.transform = rotateValue
            
            //Get the center of editingFrame from helperView to designView
            guard let view = sender.view else { return }
            
            let center = view.convert(helperView.editingFrame.center, to: designView)
            
            //Make editingView's center equal to editingFrame's center
            editingView?.center = center
            
            editingView?.transform = rotateValue
            
            sender.rotation = 0
            
        }
        
        helperView.showHelper(after: sender)
        
    }
    
    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        
        guard  sender.view != nil else {
            return
            
        }
        
        if sender.state == .began || sender.state == .changed {
            
            guard let transform = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale) else {
                
                return
            }
            
            sender.view?.transform = transform
            
            guard let center = sender.view?.convert(helperView.editingFrame.center, to: designView) else { return }
            
            editingView?.center = center
            
            editingView?.transform = transform
            
            sender.scale = 1
            
            return
            
        }
        
        helperView.showHelper(after: sender)
    }
    
    @objc func handleDragged( _ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.view)
        
        guard let xCenter = editingView?.center.x, let yCenter = editingView?.center.y else { return }
        
        editingView?.center = CGPoint(x: xCenter+translation.x, y: yCenter+translation.y)
        gesture.setTranslation(CGPoint.zero, in: editingView)
        
        guard let center = editingView?.center else { return }
        helperView.center = center
        
        let view = gesture.view
        guard let xCenter2 = view?.center.x, let yCenter2 = view?.center.y else { return }
        
        view?.center = CGPoint(x: xCenter2+translation.x, y: yCenter2+translation.y)
        gesture.setTranslation(CGPoint.zero, in: view)
        
        helperView.showHelper(after: gesture)
        
    }
    
    @objc func handleCircleGesture(sender: UIPanGestureRecognizer) {
        
        helperView.rotateHelper.increaseHitInset()
        
        let state = sender.state
        
        switch state {
            
        case .began:
            
            
            print("===========START==============")
            originLocation = sender.location(in: designView)
            
        case .changed:
            
            if let location = newLocation { originLocation = location }
            
            newLocation = sender.location(in: designView)
            
            guard let origin = editingView?.center,
                let newLocation = newLocation else { return }
            
            let newAngle = angleBetween(pointA: originLocation,
                                        pointB: newLocation,
                                        origin: origin)
            
            var originAngle: CGFloat = 0
            
            guard let angle = editingView?.transform.angleInDegrees else { return }
            
            if isClockwise(from: originLocation, to: newLocation, center: origin) {
                
                originAngle = (angle/360)*CGFloat.pi*2
                
                if originAngle+newAngle >= CGFloat.pi*2 {
                    
                    editingView?.transform = CGAffineTransform(rotationAngle: originAngle+newAngle-CGFloat.pi*2)
                    
                } else {
                    
                    editingView?.transform =
                        CGAffineTransform(rotationAngle: originAngle+newAngle)
                    
                }
                
            } else {
                
                originAngle = (angle/360)*CGFloat.pi*2
                
                if originAngle-newAngle <= 0 {
                    
                    editingView?.transform = CGAffineTransform(rotationAngle: originAngle-newAngle+CGFloat.pi*2)
                    
                } else {
                    
                    editingView?.transform =
                        CGAffineTransform(rotationAngle: originAngle-newAngle)
                    
                }
                
            }
            
            guard let editingView = editingView else { return }
            
            helperView.resize(accordingTo: editingView)
            
        default:
            
            helperView.rotateHelper.decreaseHitInset()
            
            helperView.showHelper(after: sender)
        }
        
    }
    
    @objc func handleSizeHelper(sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: designView)
        
        guard let editingView = editingView,
            let helper = sender.view as? SizeHelperView else { return }
        
        let distance = CGPointDistance(from: editingView.center, to: location)
        
        var reduce = editingView.bounds.width-distance
        
        let oldCenter =  editingView.center
        
        let angle = editingView.transform.angle
        
        let transform = editingView.transform
        
        editingView.transform = CGAffineTransform(rotationAngle: 0)
        
        switch helper.direct {
        case .top?:
            
            reduce = editingView.bounds.height-distance
            
            editingView.frame = CGRect(x: editingView.frame.origin.x,
                                       y: editingView.frame.origin.y+reduce,
                                       width: editingView.frame.width,
                                       height: editingView.frame.height-reduce)
        case .bottom?:
            
            reduce = editingView.bounds.height-distance
            editingView.frame = CGRect(x: editingView.frame.origin.x,
                                       y: editingView.frame.origin.y,
                                       width: editingView.frame.width,
                                       height: editingView.frame.height-reduce)
        case .left?:
            editingView.frame = CGRect(x: editingView.frame.origin.x+reduce,
                                       y: editingView.frame.origin.y,
                                       width: editingView.frame.width-reduce,
                                       height: editingView.frame.height)
        case .right?:
            editingView.frame = CGRect(x: editingView.frame.origin.x,
                                       y: editingView.frame.origin.y,
                                       width: editingView.frame.width-reduce,
                                       height: editingView.frame.height)
        default: break
        }
        
        editingView.center = movePoint(target: editingView.center, aroundOrigin: oldCenter, byDegree: angle)
        
        editingView.transform = transform
        
        if let textView = editingView as? UITextView {
            
            textView.resize()
            
        }
        
        helperView.resize(accordingTo: editingView)
        
        helperView.showHelper(after: sender)
        
    }
    
}

extension EditingViewController: ImageEditContainerVCDelegate {
    
    func transparencyChange(to alpha: CGFloat) {
        
        editingView?.alpha = alpha
        
    }
    
    func changeEditingViewColor(with color: UIColor) {
        
        if let view = editingView as? UIImageView {
            
            view.image = nil
            view.backgroundColor = color
            
        } else if let view = editingView as? ALShapeView {
            
            view.redrawWith(color)
        }
        
    }
    
    func pickImageWithAlbum() {
        
        self.present(fusumaAlbum, animated: true, completion: nil)
        
    }
    
    func pickImageWithCamera() {
        
        self.present(fusumaCamera, animated: true, completion: nil)
        
    }
}

extension EditingViewController: BaseContainerViewControllerDelegate {
    
    func changeColor(to color: UIColor) {
        
        guard let view = editingView as? UIImageView else {
            
            guard let view = editingView as? ALShapeView else { return }
            
            view.redrawWith(color)
            
            return
        }
        view.image = nil
        view.backgroundColor = color
        
    }
    
    func showPhotoLibrayAlert() {
        
        openLibraryAlert.alpha = 1
        openLibraryAlert.addOn(self.view)
        openLibraryAlert.titleLabel.text = AlertTitle.openPhotoLibrary.rawValue
    }
    
    func showCameraAlert() {
        
        openCameraAlert.alpha = 1
        openCameraAlert.addOn(self.view)
        openCameraAlert.titleLabel.text = AlertTitle.openCamera.rawValue
    }
    
    func changeImageWith(filter: FilterType?) {
        
        guard let imageView = editingView as? ALImageView else {
            return
        }
        
        guard let fileName = imageView.imageFileName else { return }
        
        let originImage = loadImageFromDiskWith(fileName: fileName)
        
        if let filter = filter {
            
            DispatchQueue.main.async { [weak imageView] in
                
                imageView?.image = originImage?.addFilter(filter: filter)
                
            }
            
            imageView.filterName = filter
            
        } else {
            
            DispatchQueue.main.async { [weak imageView] in
                
                imageView?.image = originImage
                
            }
            
            imageView.filterName = nil
            
        }
        
    }
    
    @objc func handleCornerResize(gesture: UIPanGestureRecognizer) {
        
        let location = gesture.location(in: designView)
        
        var originDistance: CGFloat = 0
        
        var newDistance: CGFloat = 0
        
        switch gesture.state {
            
        case .began:
            
            originLocation = CGPoint(x: location.x,
                                     y: location.y)
            
            if let width = editingView?.bounds.width,
                let height = editingView?.bounds.height {
                
                originSize = CGSize(width: width, height: height)
                
            }
            
        case .changed:
            
            let location = gesture.location(in: designView)
            
            newDistance = CGPointDistance(from: location, to: (editingView?.center)!)
            
            originDistance = CGPointDistance(from: originLocation, to: (editingView?.center)!)
            
            let scale = newDistance/originDistance
            
            let width = (originSize.width)*scale
            
            let height = (originSize.height)*scale
            
            editingView?.bounds.size = CGSize(width: width, height: height)
            
            helperView.resize(accordingTo: editingView!)
            
            if let textView = editingView as? UITextView {
                
                textView.updateTextFont()
                
            }
            
        default:
            
            helperView.resize(accordingTo: editingView!)
            
            helperView.showHelper(after: gesture)
            
        }
        
    }

}
