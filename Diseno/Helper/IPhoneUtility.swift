//
//  IPhoneUtility.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/8/1.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit

class IPhoneUtility: NSObject {
    static func isNotchFeaturedIPhone() -> Bool {
        if #available(iOS 11, *) {
            if UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > CGFloat(0) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
