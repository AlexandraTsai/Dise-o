//
//  ViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/1.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var designView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.isHidden = true
        addGesture()
    }

}

extension ViewController {
    
    func addGesture() {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewClicked(_:)))
        designView.addGestureRecognizer(gesture)
        
    }
    
    @objc func viewClicked(_ sender: UITapGestureRecognizer) {
        print("image tap working.")
        
        containerView.isHidden = false
      
    }
}
