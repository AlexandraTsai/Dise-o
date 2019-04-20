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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(newDesignView)
        newDesignView.isHidden = true

    }
 
    @IBAction func addButtonTapped(_ sender: UIButton) {
        self.setupInputView()
        newDesignView.alpha = 0
   
        UIView.animate(withDuration: 0.7, animations: {
            self.newDesignView.alpha = 1
          
        })
        
        newDesignView.textField.delegate = self
        newDesignView.textField.becomeFirstResponder()
      
    }
    
    func setupInputView() {
        
        newDesignView.isHidden = false

        //Auto Layout
        newDesignView.translatesAutoresizingMaskIntoConstraints = false
        
        newDesignView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        newDesignView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        newDesignView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        newDesignView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
 
        newDesignView.cancelButton.addTarget(self,
                                             action: #selector(cancelButtonTapped(sender:)),
                                             for: .touchUpInside)
        newDesignView.confirmButton.addTarget(self,
                                              action: #selector(confirmButtonTapped(sender:)),
                                              for: .touchUpInside)
       
    }
    
    @objc func cancelButtonTapped(sender: UIButton) {
        
        UIView.animate(withDuration: 0.7, animations: {
            
            self.newDesignView.isHidden = true
            
            //To hide the keyboard
            self.view.endEditing(true)
            
        })
       
    }
    
    @objc func confirmButtonTapped(sender: UIButton) {
        
        newDesignView.isHidden = true
        
        //To hide the keyboard
        self.view.endEditing(true)
        
        guard let designVC = UIStoryboard(
            name: "Main",
            bundle: nil).instantiateViewController(
                withIdentifier: String(describing: DesignViewController.self)) as? DesignViewController
            else { return }
        
        show(designVC, sender: nil)
        
    }
    
    func setupNavigationBar() {
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
}
