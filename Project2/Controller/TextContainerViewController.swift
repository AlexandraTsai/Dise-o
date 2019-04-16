//
//  TextContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/16.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class TextContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        let notificationName = Notification.Name(NotiName.addElementButton.rawValue)
        
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.addElementButton: true])
        
    }
    
    @IBAction func usedColorBtnTapped(_ sender: Any) {
    }
    @IBAction func defaultColorBtnTapped(_ sender: Any) {
    }
}
