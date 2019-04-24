//
//  SaveSuccessView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/24.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class SaveSuccessLabel: UILabel {
   
    func setupLabel(on vc: UIViewController, with title: String) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: vc.view.topAnchor).isActive = true
        
        self.backgroundColor = UIColor.init(red: 252/255, green: 195/255, blue: 37/255, alpha: 1)
        
        self.text = title
        self.textAlignment = .center
        self.font = UIFont(name: FontName.futura.rawValue, size: 13)
        self.textColor = UIColor.white
    }

}
