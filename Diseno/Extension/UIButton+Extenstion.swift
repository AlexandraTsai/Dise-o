//
//  UIButton+Extenstion.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/7.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

extension UIButton {

    func disableMode() {

        self.isEnabled = false
        self.setTitleColor(UIColor.gray, for: .normal)
    }

    func enableMode() {

        self.isEnabled = true
        self.setTitleColor(UIColor.white, for: .normal)
    }
}
