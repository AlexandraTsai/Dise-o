//
//  ALCustomView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/4.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

@IBDesignable open class ALCustomView: UIView {

    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)

        }
        set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }

    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)

        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
}
