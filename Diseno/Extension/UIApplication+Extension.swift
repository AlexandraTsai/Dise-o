//
//  UIApplication+Extension.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/8/14.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit

extension UIApplication {
    var appWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .first { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
                .map { $0 as? UIWindowScene }
                .map { $0?.windows.first } ?? UIApplication.shared.delegate?.window ?? nil
        }
        return UIApplication.shared.delegate?.window ?? nil
    }
}
