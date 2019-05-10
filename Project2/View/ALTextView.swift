//
//  ALTextView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/22.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class ALTextView: UITextView {
    
    var index: Int?
    
    var originalText: String? = ""
    
    override func awakeFromNib() {
        originalText = self.text
    }
}
