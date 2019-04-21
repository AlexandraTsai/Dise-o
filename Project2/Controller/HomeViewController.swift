//
//  HomeViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/18.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    var newDesignView = NewDeign()
    
    var design = ALDesignView()
    
    var designs: [Design] = [] {
        
        didSet {
            
            if designs.count == 0 {
                
            } else {
                
                print("-----Fetch success------------")
                
                print(designs.count)
                
                for object in 0...designs.count-1 {
                    
                    print(designs[object].designName)
                    
                    guard let frame = designs[object].frame as? CGRect else { return }
                    
                     print(frame)
                    
                    if designs[object].backgroundColor != nil {
                        
                        guard let color = designs[object].backgroundColor as? UIColor else { return }
                        print(color)
                    }
                    
                    if designs[object].backgroundImage != nil {
                        
                        guard let backgroundImage = designs[object].backgroundImage as? UIImage else { return }
                        print(backgroundImage)
                    }
                    
                    if designs[0].images != nil {
                        
                        guard let array = designs[0].images else { return }
                        
                        let subImages = Array(array)
                        
                        print(subImages)
                        
                        guard let alArray = subImages as? [Image] else { return }
                        
                        print(alArray)
                        
                        for view in alArray {
                            
                            print(view.image)
                                
                            let imageView = UIImageView(frame: CGRect(x: 30, y: 20, width: 100, height: 100))
                            
                            guard let image = view.image as? UIImage else { return }
                            
                            imageView.image = image
                            
                            self.view.addSubview(imageView)
                          
                        }
                        
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupNavigationBar()
        
        fetchData()
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
        
        guard let text = newDesignView.textField.text else { return }
        
        designVC.loadViewIfNeeded()
        
        designVC.designView.designName = text
        
        show(designVC, sender: nil)
        
    }
    
    func setupNavigationBar() {
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    func fetchData() {
        
        StorageManager.shared.fetchDesigns(completion: { result in
            
            switch result {
                
            case .success(let designs):
                
                self.designs = designs
                
            case .failure(_):
                
                print("讀取資料發生錯誤")
            }
        })
    }
}
