//
//  Swift+Extension.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/7/17.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import Foundation

// prepare class instance
infix operator -->
func --> <T>(object: T, closure: (T) -> Void) -> T {
    closure(object)
    return object
}
