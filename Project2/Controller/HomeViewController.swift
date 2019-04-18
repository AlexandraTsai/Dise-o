//
//  HomeViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/18.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    var newDesignView = NewDeign()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(newDesignView)
        newDesignView.isHidden = true

        // Do any additional setup after loading the view.
    }
 
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        setupInputView()
        
    }
    
    func setupInputView() {
        
        newDesignView.isHidden = false
        
        //Auto Layout
        newDesignView.translatesAutoresizingMaskIntoConstraints = false
        
        newDesignView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        newDesignView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        newDesignView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        newDesignView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        
        newDesignView.textField.delegate = self
        newDesignView.textField.becomeFirstResponder()
        
        newDesignView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc func cancelButtonTapped(sender: UIButton) {
        newDesignView.isHidden = true
        self.view.endEditing(true)
//        self.view.becomeFirstResponder()
    }
}
