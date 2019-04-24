//
//  SelectionView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/23.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class SelectionView: UIView {
    
    let openButton = UIButton()
    let saveButton = UIButton()
    let renameButton = UIButton()
    let deleteButton = UIButton()
    
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
        self.addSubview(saveButton)
        self.addSubview(renameButton)
        self.addSubview(deleteButton)
        self.addSubview(openButton)
        self.addSubview(cancelButton)
        self.addSubview(closeButton)
        
        //Auto layout
 
        //Open Button
        openButton.translatesAutoresizingMaskIntoConstraints = false
        openButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        openButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -10).isActive = true
        openButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        openButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        openButton.heightAnchor.constraint(equalTo: saveButton.heightAnchor, multiplier: 1)
        openButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //Save Button
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.bottomAnchor.constraint(equalTo: renameButton.topAnchor, constant: -10).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: openButton.leadingAnchor).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: openButton.trailingAnchor).isActive = true
        saveButton.heightAnchor.constraint(equalTo: openButton.heightAnchor, multiplier: 1).isActive = true
        
        //Rename Button
        renameButton.translatesAutoresizingMaskIntoConstraints = false
        renameButton.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -10).isActive = true
        renameButton.leadingAnchor.constraint(equalTo: openButton.leadingAnchor).isActive = true
        renameButton.trailingAnchor.constraint(equalTo: openButton.trailingAnchor).isActive = true
        renameButton.heightAnchor.constraint(equalTo: openButton.heightAnchor, multiplier: 1).isActive = true
        
        //Delete Button
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: openButton.leadingAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: openButton.trailingAnchor).isActive = true
        deleteButton.heightAnchor.constraint(equalTo: openButton.heightAnchor, multiplier: 1).isActive = true
        
        //Cancel Button
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //Close Button
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.setImage(#imageLiteral(resourceName: "noun_Cancel"), for: .normal)
    }
    
    func setupButtonTitles() {
       
        openButton.setTitle("Open", for: .normal)
        saveButton.setTitle("Save Image", for: .normal)
        renameButton.setTitle("Rename", for: .normal)
        deleteButton.setTitle("Delete", for: .normal)
        cancelButton.setTitle("CANCEL", for: .normal)
        
        openButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 16)
        saveButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 16)
        renameButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 16)
        deleteButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 16)
        cancelButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 13)
        
        openButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        renameButton.setTitleColor(UIColor.white, for: .normal)
        deleteButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        
    }
    
    func setupButtonColor() {
        
        openButton.backgroundColor = UIColor.black
        saveButton.backgroundColor = UIColor.black
        renameButton.backgroundColor = UIColor.black
        deleteButton.backgroundColor = UIColor.gray
        cancelButton.backgroundColor = UIColor.white
        
        cancelButton.layer.borderColor = UIColor.black.cgColor
        cancelButton.layer.borderWidth = 1
        
        openButton.layer.cornerRadius = 17
        saveButton.layer.cornerRadius = 17
        renameButton.layer.cornerRadius = 17
        deleteButton.layer.cornerRadius = 17
        cancelButton.layer.cornerRadius = 15
        
    }
    
    func addOn(_ specificView: UIView) {
        
        specificView.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 270).isActive = true
        self.bottomAnchor.constraint(equalTo: specificView.bottomAnchor, constant: -30).isActive = true
        self.leadingAnchor.constraint(equalTo: specificView.leadingAnchor, constant: 20).isActive = true
        self.trailingAnchor.constraint(equalTo: specificView.trailingAnchor, constant: -20).isActive = true
        
    }

}
