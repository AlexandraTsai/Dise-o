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

    @IBAction func addLabelBtnTapped(_ sender: Any) {
        
        let txtLabel = UILabel()
        
        txtLabel.backgroundColor = UIColor.clear
        txtLabel.textAlignment = .center
        txtLabel.textColor = UIColor.white
        txtLabel.text = "I'm a new label"
        
        designView.addSubview(txtLabel)
        
        UIGraphicsBeginImageContextWithOptions(txtLabel.bounds.size, false, 0)
        
        guard let currentContent = UIGraphicsGetCurrentContext() else {
            return
        }
        designView.layer.render(in: currentContent)
//        designView.layer.render(in: currentContent)
        
        let imageWithLabel = UIGraphicsGetImageFromCurrentImageContext() // here is final image
        UIGraphicsEndImageContext()
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        
      
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
