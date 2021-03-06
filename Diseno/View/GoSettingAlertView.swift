//
//  GoSettingAlertView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/30.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class GoSettingAlertView: UIView {
    
    let titleLabel = UILabel()
    let cancelButton = UIButton()
    let settingButton = UIButton()
    let backgroundView = UIView()
    
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
        
        backgroundView.backgroundColor = UIColor.white
        backgroundView.layer.cornerRadius = 20
        
        //Shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 12
        self.layer.shadowOpacity = 1
    }
    
    func setupLayout() {
        
        //Add sub views
//        self.addSubview(titleLabel)
//        self.addSubview(cancelButton)
//        self.addSubview(settingButton)
        self.addSubview(backgroundView)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(cancelButton)
        backgroundView.addSubview(settingButton)
        
//        self.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        //Auto layout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        settingButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        settingButton.widthAnchor.constraint(equalTo: titleLabel.widthAnchor).isActive = true
        settingButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: settingButton.bottomAnchor, constant: 10).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: settingButton.leadingAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: settingButton.trailingAnchor).isActive = true
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        backgroundView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        settingButton.layer.cornerRadius = 13
        cancelButton.layer.cornerRadius = 13
        
        settingButton.backgroundColor = UIColor.DSColor.yellow
        cancelButton.backgroundColor = UIColor.gray
        
    }
    
    func setupTitle() {
        
        //Title
        titleLabel.text =
        "Diseño does not have access to your photo library. Choose 'Settings' to change this."
        titleLabel.font = UIFont(name: FontName.futura.rawValue, size: 17)
        titleLabel.numberOfLines = 0
        
        settingButton.setTitle("Settings", for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        
        settingButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 16)
        cancelButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 16)
    }
    
    func addOn(_ specificView: UIView) {
        
        specificView.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: specificView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: specificView.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: specificView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: specificView.bottomAnchor).isActive = true
        
    }
    
    func setupAction() {
        
        cancelButton.addTarget(self, action: #selector(cancelAlert(sender:)), for: .touchUpInside)
        settingButton.addTarget(self, action: #selector(openSetting(sender:)), for: .touchUpInside)
    }
    
    @objc func cancelAlert(sender: UIButton) {
        
        self.removeFromSuperview()
        
    }
    
    @objc func openSetting(sender: UIButton) {
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
        
    }
    
}
