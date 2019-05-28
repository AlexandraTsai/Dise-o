//
//  SavedImageAlert.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/30.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class SavedImageAlert: UIView {
    
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let confirmButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
        setupLayout()
        setupTitle()
        
        setupAction()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
        
        setupLayout()
        setupTitle()
        
        setupAction()
        
    }
    
    func changeTitle(with title: String) {
        
        titleLabel.text = title
    }
    
    func setup() {
        
        self.backgroundColor = UIColor.DSColor.yellow

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
        self.addSubview(contentLabel)
        self.addSubview(confirmButton)
        
        //Auto layout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contentLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        contentLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor).isActive = true
        contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 10).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        confirmButton.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor).isActive = true
        
        confirmButton.layer.cornerRadius = 13
        confirmButton.layer.cornerRadius = 13
        
        contentLabel.backgroundColor = UIColor.DSColor.yellow
        confirmButton.backgroundColor = UIColor.gray
        
    }
    
    func setupTitle() {
        
        //Title
        titleLabel.text =
        "Saved to Camera Roll"
        titleLabel.font = UIFont(name: FontName.futura.rawValue, size: 17)
        titleLabel.numberOfLines = 0
        
//        settingButton.setTitle("Settings", for: .normal)
//        cancelButton.setTitle("Cancel", for: .normal)
//        
//        settingButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 16)
//        cancelButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 16)
    }
    
    func addOn(_ specificView: UIView) {
        
        specificView.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 220).isActive = true
        self.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.centerXAnchor.constraint(equalTo: specificView.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: specificView.centerYAnchor).isActive = true
        
    }
    
    func setupAction() {
        
        confirmButton.addTarget(self, action: #selector(cancelAlert(sender:)), for: .touchUpInside)
    }
    
    @objc func cancelAlert(sender: UIButton) {
        
        self.removeFromSuperview()
        
    }
    
}
