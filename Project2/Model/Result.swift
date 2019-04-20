//
//  Result.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/19.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import Foundation

enum Result<T> {
    
    case success(T)
    
    case failure(Error)
}
