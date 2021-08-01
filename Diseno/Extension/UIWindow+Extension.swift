//
//  UIWindow+Extension.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/8/1.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit

extension UIWindow {
    public var width: CGFloat {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            return max(frame.width, frame.height)
        case .portrait, .portraitUpsideDown:
            return min(frame.width, frame.height)
        default:
            return frame.width
        }
    }

    public var height: CGFloat {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            return min(frame.width, frame.height)
        case .portrait, .portraitUpsideDown:
            return max(frame.width, frame.height)
        default:
            return frame.height
        }
    }
}
