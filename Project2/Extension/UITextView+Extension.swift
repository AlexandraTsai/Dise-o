//
//  UIViewController+Extension.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/4.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

extension UITextView{
    
    @IBInspectable var doneAccessory: Bool{
        
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
    func makeACopy(from oldView: UITextView) {
        
        self.inputView = oldView.inputView
        self.textContainer.size = oldView.textContainer.size
        self.frame = oldView.frame


        self.backgroundColor = oldView.backgroundColor

        self.text = oldView.text
        self.font = oldView.font
        self.tintColor = oldView.tintColor
        self.textAlignment = oldView.textAlignment
    
    }
}
