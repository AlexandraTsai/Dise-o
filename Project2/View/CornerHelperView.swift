//
//  CornerHelperView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/1.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class CornerHelperView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    func setupView() {
        
        self.bounds.size = CGSize(width: 10, height: 10)
        
//        self.layer.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.white
        
        self.layer.cornerRadius = 5
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.8
    }
    
}
