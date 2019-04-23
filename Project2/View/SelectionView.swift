//
//  SelectionView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/23.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class SelectionView: UIView {
    
    let deleteButton = UIButton()
    let openButton = UIButton()
    let cancelButton = UIButton()
    let closeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
        setupLayout()
        setupButtonTitles()
        setupButtonColor()
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
        
        setupLayout()
        setupButtonTitles()
        setupButtonColor()
     
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
        self.addSubview(deleteButton)
        self.addSubview(openButton)
        self.addSubview(cancelButton)
        self.addSubview(closeButton)
        
        //Auto layout
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 10).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10).isActive = true
        deleteButton.topAnchor.constraint(equalTo: openButton.bottomAnchor, constant: 10).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
//        deleteButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        openButton.translatesAutoresizingMaskIntoConstraints = false
        openButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        openButton.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -10).isActive = true
        openButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        openButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        openButton.heightAnchor.constraint(equalTo: deleteButton.heightAnchor, multiplier: 1)
        
//        cancelButton.translatesAutoresizingMaskIntoConstraints = false
//        cancelButton.centerYAnchor.constraint(equalTo: openButton.centerYAnchor).isActive = true
//        cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
//        cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
//        cancelButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        cancelButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        cancelButton.setImage(#imageLiteral(resourceName: "noun_Cancel"), for: .normal)
    }
    
    func setupButtonTitles() {
     
        cancelButton.setTitle("CANCEL", for: .normal)
        deleteButton.setTitle("Delete", for: .normal)
        openButton.setTitle("Open", for: .normal)
        
        cancelButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 15)
        deleteButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 19)
        openButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 19)
        
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        deleteButton.setTitleColor(UIColor.white, for: .normal)
        openButton.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    func setupButtonColor() {
        
        openButton.backgroundColor = UIColor.black
        deleteButton.backgroundColor = UIColor.black
        cancelButton.backgroundColor = UIColor.white
        
        cancelButton.layer.borderColor = UIColor.black.cgColor
        cancelButton.layer.borderWidth = 1
        
        openButton.layer.cornerRadius = 20
        deleteButton.layer.cornerRadius = 20
        cancelButton.layer.cornerRadius = 20
        
    }
    
    func addOn(_ specificView: UIView) {
        
        specificView.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 400).isActive = true
        self.bottomAnchor.constraint(equalTo: specificView.bottomAnchor, constant: -20).isActive = true
        self.leadingAnchor.constraint(equalTo: specificView.leadingAnchor, constant: 20).isActive = true
        self.trailingAnchor.constraint(equalTo: specificView.trailingAnchor, constant: -20).isActive = true
        
    }
}
