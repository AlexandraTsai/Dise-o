//
//  DeleteView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/6.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class DeleteView: UIView {
    
    let titleLabel = UILabel()
    let cancelButton = UIButton()
    let deleteButton = UIButton()
    
    deinit {
        print("new design view is deinit")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
        setupLayout()
        settingForTitleLabel()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
        
        setupLayout()
        settingForTitleLabel()
     
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
        self.addSubview(deleteButton)
        self.addSubview(cancelButton)

        //Auto layout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        cancelButton.setImage(#imageLiteral(resourceName: "noun_Cancel"), for: .normal)
    
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        deleteButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        deleteButton.layer.cornerRadius = 20
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 16)
        deleteButton.backgroundColor = UIColor.DSColor.red
        
    }
    
    func settingForTitleLabel() {
        //Title
        titleLabel.text = "Are you sure you want to delete?"
        titleLabel.font = UIFont(name: FontName.futura.rawValue, size: 20)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
    }
    
    func addOn(_ specificView: UIView) {
        
        specificView.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 150).isActive = true
        self.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.centerXAnchor.constraint(equalTo: specificView.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: specificView.centerYAnchor).isActive = true
        
    }

}
