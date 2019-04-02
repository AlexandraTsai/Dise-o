//
//  ViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/1.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

struct NotificationInfo {
    
    static let newText = ""
    static let newImage = UIImage()
    
}

class ViewController: UIViewController {

    @IBOutlet weak var designView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.isHidden = true
        addGesture(to: designView, action: #selector(designViewClicked(_:)))
//        addGesture(to: self.view, action:  #selector(viewClicked(_:)))
        
        createNotification()
    }

    @IBAction func saveBtnTapped(_ sender: Any) {

        UIImageWriteToSavedPhotosAlbum(designView.image!, self, #selector(image(_: didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func addLabelBtnTapped(_ sender: Any) {
        
        let txtLabel = UILabel(frame: CGRect(x: designView.frame.origin.x, y:designView.frame.origin.y, width: 200, height: 100))
        
        txtLabel.backgroundColor = UIColor.blue
        txtLabel.textAlignment = .center
        txtLabel.textColor = UIColor.red
    
        txtLabel.text = "I'm a new label"
        txtLabel.font.withSize(100)
        
        designView.addSubview(txtLabel)
        
        UIGraphicsBeginImageContextWithOptions(designView.bounds.size, false, 0)
        
        guard let currentContent = UIGraphicsGetCurrentContext() else {
            return
        }
        designView.layer.render(in: currentContent)
        //        txtLabel.layer.render(in: currentContent)
        
        // here is final image
        guard let imageWithLabel = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
        designView.image = imageWithLabel
        UIGraphicsEndImageContext()
      
        //Enable label to rotate
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(sender:)))
        txtLabel.addGestureRecognizer(rotate)
        txtLabel.isUserInteractionEnabled = true
         //Enable to move label
//        let move = UITapGestureRecognizer(target: self, action: #selector(moveLabel(sender:)))
//        txtLabel.addGestureRecognizer(move)
    
    }
    
    @objc func handleRotation(sender: UIRotationGestureRecognizer) {
        
        guard  sender.view != nil else {
            return
            
        }
        
        if sender.state == .began || sender.state == .changed {
            sender.view?.transform = (sender.view?.transform.rotated(by: sender.rotation))!
            sender.rotation = 0
        }
    }
    
    @objc func move(view: UIView, sender: UITapGestureRecognizer) {
        
//        view.animate(withDuration: 2.0) {
//            self.centerHorizontalConstraint.constant -= 50
//            self.view.layoutIfNeeded()
//        }
        
    }
}

extension ViewController {
    
    func addGesture(to view: UIView, action: Selector) {
        
        let gesture = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(gesture)
        
    }
    
    @objc func designViewClicked(_ sender: UITapGestureRecognizer) {
       
        if designView.image == nil {
            containerView.isHidden = false
        } else {
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageEditViewController") as? ImageEditViewController else { return }
            self.show(vc, sender: nil)
        }
        
    }
    
    @objc func viewClicked(_ sender: UITapGestureRecognizer){
        print("I'm clicked")
        
//        if containerView.isHidden == false {
//            containerView.isHidden = true
//        }
    }
    
    //Notification for image picked
    func createNotification() {
        
        // 註冊addObserver
        let notificationName = Notification.Name("changeImage")
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeImage(noti:)), name: notificationName, object: nil)
    }
    
    // 收到通知後要執行的動作
    @objc func changeImage(noti: Notification) {
        if let userInfo = noti.userInfo,
            let newImage = userInfo[NotificationInfo.newImage] as? UIImage {
            designView.image = newImage
        }
    }
}
