//
//  AccessAlertHandler.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/11/11.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import Foundation
import UIKit

enum AccessAlertHandler {
    static func alert(for accessType: AccessType) -> UIAlertController {
        let alert = UIAlertController(title: "Please Allow Access",
                                      message: accessType.message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings",
                                      style: UIAlertAction.Style.default,
                                      handler: { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(url)
        }))
        alert.addAction(UIAlertAction(title: "Not Now",
                                      style: UIAlertAction.Style.cancel))
        return alert
    }
}

enum AccessType {
    case photo, camera

    var message: String {
        switch self {
        case .photo:
            return "Please visit Settings > Privacy > Photos. Under ALLOW PHOTOS ACCESS, select Read and Write."
        case .camera:
            return "Please visit Settings > Privacy > Camera, then allow camera access"
        }
    }
}
