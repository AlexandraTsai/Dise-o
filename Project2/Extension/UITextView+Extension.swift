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
    
    func updateTextFont() {
        
        if (self.text.isEmpty || self.bounds.size.equalTo(CGSize.zero)) { return }
        
        let textViewSize = self.frame.size;
        let fixedWidth = textViewSize.width;
        let expectSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
        
        var expectFont = self.font
        if (expectSize.height > textViewSize.height) {
            
            while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = self.font!.withSize(self.font!.pointSize - 1)
                self.font = expectFont
            }
        }
        else {
            while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = self.font
                self.font = self.font!.withSize(self.font!.pointSize + 1)
            }
            self.font = expectFont
        }
    }
    
    func keepAttributeWith(lineHeight: Float, letterSpacing: Float, fontName: String, fontSize: CGFloat) {
       
        let align = self.textAlignment
        
        //Line Height
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(lineHeight)
        
        let attributedString = NSMutableAttributedString(string: self.text)
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        let range = NSRange(location: 0, length: attributedString.length)
        //Letter Spacing
        attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: range)
        
        //Font
        guard let font = UIFont(name: fontName, size: fontSize) else { return }
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: attributedString.length))
      
        self.attributedText = attributedString
        
//        print(self.attributedText.font)
        
        self.textAlignment = align
        
    }
}
