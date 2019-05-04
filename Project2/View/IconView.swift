//
//  IconView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/4.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class IconView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        self.backgroundColor = UIColor.green
        self.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
        
    }
}
