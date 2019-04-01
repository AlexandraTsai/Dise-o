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
        addGesture()
        
        createNotification()
    }

}

extension ViewController {
    
    func addGesture() {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewClicked(_:)))
        designView.addGestureRecognizer(gesture)
        
    }
    
    @objc func viewClicked(_ sender: UITapGestureRecognizer) {
        print("image tap working.")
        
        containerView.isHidden = false
      
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
