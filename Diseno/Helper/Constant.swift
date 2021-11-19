//
//  Constant.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/8/28.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import Foundation
import UIKit

enum Constant {
    static let padding: CGFloat = 16
    static var boardWidth: CGFloat {
        screenSize.width - padding * 2
    }
    static var imageDefualtFrame: CGRect {
        let padding = (boardWidth / 2) / 2
        let w = boardWidth / 2
        // At the center of the design board
        // with half width and height of the board
        return .init(origin: .init(x: padding, y: padding),
                     size: .init(width: w, height: w))
    }
}
