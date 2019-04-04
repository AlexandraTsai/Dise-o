//
//  ImageEditViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/1.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class ImageEditViewController: UIViewController {
    
    var editingView: UIView?

    @IBOutlet weak var designView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
    }
  
    override func viewWillAppear(_ animated: Bool) {
        
        for i in 0...designView.subviews.count-1 {
            addAllGesture(to: designView.subviews[i])
        }
        
    }
}

//Setup Navigation Bar
extension ImageEditViewController {
    
    func setupNavigationBar() {
        let button1 = UIBarButtonItem(image: UIImage(named: ImageAsset.Icon_Crop.rawValue), style: .plain, target: self, action: #selector(didTapCropButton(sender:)))
        
        let button2 = UIBarButtonItem(image: UIImage(named: ImageAsset.Icon_TrashCan.rawValue), style: .plain, target: self, action: #selector(didTapDeleteButton(sender:)))
        
        let button3 = UIBarButtonItem(image: UIImage(named: ImageAsset.Icon_down.rawValue), style: .plain, target: self, action: #selector(didTapDownButton(sender:)))
        
        let button4 = UIBarButtonItem(image: UIImage(named: ImageAsset.Icon_up.rawValue), style: .plain, target: self, action: #selector(didTapUpButton(sender:)))
        
        let button5 = UIBarButtonItem(image: UIImage(named: ImageAsset.Icon_Copy.rawValue), style: .plain, target: self, action: #selector(didTapCopyButton(sender:)))
        
        self.navigationItem.rightBarButtonItems  = [button1, button2, button3, button4, button5]
        
        //Left Buttons
        let leftButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton(sender:)))
        self.navigationItem.leftBarButtonItem  = leftButton
        
    }
    
    @objc func didTapDoneButton(sender: AnyObject) {
        
        /*Notification*/
        let notificationName = Notification.Name(NotiName.updateImage.rawValue)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: [NotificationInfo.editedImage: designView.subviews])

        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func didTapCropButton(sender: AnyObject) {
        
        
    }
    
    @objc func didTapDeleteButton(sender: AnyObject) {
        
        
    }
    
    @objc func didTapDownButton(sender: AnyObject) {
        print("profile btn tapped")
        
    }
    
    @objc func didTapUpButton(sender: AnyObject) {
        print("profile btn tapped")
        
    }
    
    @objc func didTapCopyButton(sender: AnyObject) {
        print("profile btn tapped")
        
    }

}

//Setup Gesture
extension ImageEditViewController {
    
    func addAllGesture(to newView: UIView){
        
    
//        for i in 0...newView.count-1 {
        
            newView.isUserInteractionEnabled = true
            
            //Handle label to tapped
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            newView.addGestureRecognizer(tap)
            
            //Enable label to rotate
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(sender:)))
            newView.addGestureRecognizer(rotate)
            
            //Enable to move label
            let move = UIPanGestureRecognizer(target: self, action: #selector(handleDragged(_ :)))
            newView.addGestureRecognizer(move)
            
            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
            newView.addGestureRecognizer(pinch)
        
            print("--------*********----------")
            print(self)
            print(newView.gestureRecognizers)
            
//        }
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        guard  sender.view != nil else {
            return
            
        }
        
        editingView = sender.view
        editingView?.layer.borderColor = UIColor.white.cgColor
        editingView?.layer.borderWidth = 1
    }
    
    
    @objc func handleRotation(sender: UIRotationGestureRecognizer) {
        
        guard  sender.view != nil else {
            return
            
        }
        
        if sender.state == .began || sender.state == .changed {
            
            guard let rotateValue = sender.view?.transform.rotated(by: sender.rotation) else {
                return
            }
            
            sender.view?.transform = rotateValue
            sender.rotation = 0
            
        }
    }
    
    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        
        guard  sender.view != nil else {
            return
            
        }
        
        if sender.state == .began || sender.state == .changed {
            
            guard let transform = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale) else { return }
            
            sender.view?.transform = transform
            sender.scale = 1.0
            
        }
    }
    
    @objc func handleDragged( _ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        let view = gesture.view
        
        guard let xCenter = view?.center.x, let yCenter = view?.center.y else { return }
        
        view?.center = CGPoint(x: xCenter+translation.x, y: yCenter+translation.y)
        gesture.setTranslation(CGPoint.zero, in: view)
        
    }
}
