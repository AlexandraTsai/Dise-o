//
//  ALDesignView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/20.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class ALDesignView: UIImageView {
    
    var designName: String = ""
    
    var createTime = Int64(Date().timeIntervalSince1970)
    
    var subImages = [ALImageView]()
    
}
