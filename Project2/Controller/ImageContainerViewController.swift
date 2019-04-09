//
//  ImageContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/2.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class ImageContainerViewController: UIViewController {

    @IBOutlet weak var imageToBeEdit: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createNotification()
    }
    
    //Notification for image picked
    func createNotification() {
        
        // 註冊addObserver
        let notificationName = Notification.Name(NotiName.changeBackground.rawValue)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeImage(noti:)), name: notificationName, object: nil)
    }
    
    // 收到通知後要執行的動作
    @objc func changeImage(noti: Notification) {
        if let userInfo = noti.userInfo,
            let newImage = userInfo[NotificationInfo.newImage] as? UIImage {
            imageToBeEdit.image = newImage
        }
    }
}
