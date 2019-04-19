//
//  NewDeign.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/18.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class NewDeign: UIView {
    
    let titleLabel = UILabel()
    let textField = UITextField()
    let cancelButton = UIButton()
    let confirmButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
        setupLayout()
        settingForTitleLabel()
        settingForTextField()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
        
        setupLayout()
        settingForTitleLabel()
        settingForTextField()
    }
    
    func setup() {
        
//        self.layer.borderColor = UIColor.lightGray.cgColor
//        self.layer.borderWidth = 2
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 20
        
        //Shadow
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 1
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    func setupLayout() {
        
        //Add sub views
        self.addSubview(titleLabel)
        self.addSubview(textField)
        self.addSubview(cancelButton)
        self.addSubview(confirmButton)
        
        //Auto layout
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        cancelButton.setImage(#imageLiteral(resourceName: "noun_Cancel"), for: .normal)
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.centerXAnchor.constraint(equalTo: textField.centerXAnchor).isActive = true
        confirmButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 25).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
        confirmButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        confirmButton.layer.cornerRadius = 20
        confirmButton.setTitle("CREATE", for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 16)
        confirmButton.backgroundColor = UIColor.black
        
    }
    
    func settingForTitleLabel() {
        //Title
        titleLabel.text = "New Design"
        titleLabel.font = UIFont(name: FontName.futura.rawValue, size: 20)
        
    }
    
    func settingForTextField() {
        
        textField.placeholder = "Name your design"
        textField.backgroundColor = UIColor.white

        textField.layer.shadowColor = UIColor.gray.cgColor
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        textField.layer.shadowRadius = 0.0
        textField.layer.shadowOpacity = 1.0
        
    }
   
}
