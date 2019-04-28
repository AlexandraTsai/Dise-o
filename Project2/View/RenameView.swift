//
//  RenameView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/24.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class RenameView: UIView {
    
    let titleLabel = UILabel()
    let textField = UITextField()
    let cancelButton = UIButton()
    let saveButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
        setupLayout()
        setupTitle()
        settingForTextField()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
        
        setupLayout()
        setupTitle()
        settingForTextField()
    }
    
    func setup() {
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 20
        
        //Shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 12
        self.layer.shadowOpacity = 1
    }
    
    func setupLayout() {
        
        //Add sub views
        self.addSubview(titleLabel)
        self.addSubview(textField)
        self.addSubview(cancelButton)
        self.addSubview(saveButton)
        
        //Auto layout
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -20).isActive = true
//        cancelButton.heightAnchor.constraint(equalToConstant: 27).isActive = true
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        saveButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor).isActive = true
        saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor).isActive = true
       
        saveButton.layer.cornerRadius = 13
        cancelButton.layer.cornerRadius = 13
        
        saveButton.backgroundColor = UIColor.black
        cancelButton.backgroundColor = UIColor.gray
        
    }
    
    func setupTitle() {
        
        //Title
        titleLabel.text = "Rename Design"
        titleLabel.font = UIFont(name: FontName.futura.rawValue, size: 20)
        
        saveButton.setTitle("SAVE", for: .normal)
        cancelButton.setTitle("CANCEL", for: .normal)
        
        saveButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 13)
        cancelButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 13)
    }
    
    func settingForTextField() {
        
        textField.font = UIFont(name: FontName.futura.rawValue, size: 13)
        
        textField.backgroundColor = UIColor.white
        
        textField.layer.shadowColor = UIColor.gray.cgColor
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        textField.layer.shadowRadius = 0.0
        textField.layer.shadowOpacity = 1.0
        
    }
    
    func addOn(_ specificView: UIView) {
        
        specificView.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 140).isActive = true
        self.topAnchor.constraint(equalTo: specificView.topAnchor, constant: 50).isActive = true
        self.leadingAnchor.constraint(equalTo: specificView.leadingAnchor, constant: 20).isActive = true
        self.trailingAnchor.constraint(equalTo: specificView.trailingAnchor, constant: -20).isActive = true
        
    }
    
}
