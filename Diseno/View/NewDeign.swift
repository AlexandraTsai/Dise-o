//
//  NewDeign.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/18.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class NewDeign: UIView {
    let textField = UITextField() --> {
        $0.placeholder = "Name your design"
        $0.font = UIFont(name: FontName.futura.rawValue, size: 13)
        $0.backgroundColor = UIColor.white
        $0.layer.shadowColor = UIColor.gray.cgColor
        $0.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        $0.layer.shadowRadius = 0.0
        $0.layer.shadowOpacity = 1.0
    }
    let cancelButton = UIButton()
    let confirmButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func reset() {
        textField.text = nil
    }
   
    private let titleLabel = UILabel() --> {
        $0.text = "New Design"
        $0.font = .fontMedium(ofSize: 20)
    }
}

private extension NewDeign {
    func setup() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 20
        
        //Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 12
        layer.shadowOpacity = 1
        
        setupLayout()
    }
    
    func setupLayout() {
        //Add sub views
        [titleLabel, textField, cancelButton, confirmButton].forEach { addSubview($0) }
        
        //Auto layout
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        cancelButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.right.equalToSuperview().inset(20)
            $0.height.width.equalTo(20)
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(30)
        }
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(25)
            $0.left.right.equalToSuperview().inset(50)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        cancelButton.setImage(#imageLiteral(resourceName: "noun_Cancel"), for: .normal)
        confirmButton.layer.cornerRadius = 20
        confirmButton.setTitle("CREATE", for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 16)
        confirmButton.backgroundColor = UIColor.black
    }
}
