//
//  DSError.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/7/31.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import Foundation

enum DSError {
    case saveImageFail

    var title: String {
        switch self {
        case .saveImageFail:
            return "Fail to save image"
        }
    }
}
