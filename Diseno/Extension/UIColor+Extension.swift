//
//  UIColor+Extension.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/27.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

extension UIColor {
    struct DSColor {
        /// F1DB9B
        static var lightYellow = UIColor(hex: "F1DB9B")
        /// D7D7D7
        static var lightGray = UIColor(hex: "D7D7D7")
        /// 9DA3AA
        static var mediumGray = UIColor(hex: "9DA3AA")
        /// 89898A
        static var heavyGray = UIColor(hex: "89898A")
        /// 6F7A77
        static var lightGreen = UIColor(hex: "6F7A77")
        /// 4E7977
        static var heavyGreen = UIColor(hex: "4E7977")
        /// 85A2A0
        static var logoC2 = UIColor(hex: "85A2A0")
        /// EC877F
        static var red = UIColor(hex: "EC877F")
        /// FD9648
        static var waring = UIColor(hex: "FD9648")
        /// FF5F46
        static var error = UIColor(hex: "FF5F46")
        /// 0892FC
        static var info = UIColor(hex: "0892FC")
    }

    enum Primary {
        /// F2F2F2
        static var background = UIColor(hex: "F2F2F2")
        /// FFC325
        static var highLight = UIColor(hex: "FFC325")
    }
}

extension UIColor {
    convenience init (hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) > 6 {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
