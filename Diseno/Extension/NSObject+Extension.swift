//
//  NSObject+Extension.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/7/18.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit

extension NSObject {
    class var nameOfClass: String {
        NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UIView {
    static var nib: UINib {
        UINib(nibName: nameOfClass, bundle: nil)
    }
}
