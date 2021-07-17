//
//  FontManager.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/7/17.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum Style: String {
        case medium = "Medium"
        case mediumItalic = "MediumItalic"
        case bold = "Bold"
        case condensedExtraBold = "CondensedExtraBold"
        case condensedMedium = "CondensedMedium"
        
        var name: String { fontName + rawValue }
    }

    static func fontMedium(ofSize size: CGFloat) -> UIFont {
        guard let font = UIFont(name: Style.medium.name, size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .medium)
        }
        return font
    }
    
    static func fontBold(ofSize size: CGFloat) -> UIFont {
        guard let font = UIFont(name: Style.bold.name, size: size) else {
            return UIFont.boldSystemFont(ofSize: size)
        }
        return font
    }
    
    private static let fontName = "Futura"
}
