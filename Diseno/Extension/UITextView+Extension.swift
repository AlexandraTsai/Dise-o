//
//  UIViewController+Extension.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/4.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

extension UITextView {

    @IBInspectable var doneAccessory: Bool {

        get {
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone {
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(
            frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        
        doneToolbar.barStyle = .default
        
        doneToolbar.tintColor = UIColor.Primary.highLight

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done",
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(self.doneButtonAction))

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
        self.transform = oldView.transform

        self.backgroundColor = oldView.backgroundColor
        self.alpha = oldView.alpha

        self.text = oldView.text
        self.font = oldView.font
        self.textColor = oldView.textColor
        self.textAlignment = oldView.textAlignment

    }

    func updateTextFont() {

        if self.text.isEmpty || self.bounds.size.equalTo(CGSize.zero) { return }
        
        let oldTransform = self.transform

        self.transform = CGAffineTransform(rotationAngle: 0)
        
        let textViewSize = self.frame.size
        let fixedWidth = textViewSize.width
        let expectSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))

        var expectFont = self.font
     
        if expectSize.height > textViewSize.height {

            while self.sizeThatFits(CGSize(width: fixedWidth,
                                           height: CGFloat(MAXFLOAT))).height > textViewSize.height {
                
                guard let font = self.font else { return }
                                            
                expectFont = font.withSize(font.pointSize - 1)
               
                self.font = expectFont
             
            }
            
        } else {
            
            while self.sizeThatFits(CGSize(width: fixedWidth,
                                            height: CGFloat(MAXFLOAT))).height < textViewSize.height {

                expectFont = self.font
                                                
                guard let font = self.font else { return }
                                                
                self.font = font.withSize(font.pointSize + 1)
            }
            
            self.font = expectFont
        }
        
        self.transform = oldTransform
        
    }

    func keepAttributeWith(lineHeight: Float,
                           letterSpacing: Float,
                           fontName: String,
                           fontSize: CGFloat,
                           textColor: UIColor) {

        let align = self.textAlignment

        //Line Height
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(lineHeight)

        let attributedString = NSMutableAttributedString(string: self.text)

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))
        
        let range = NSRange(location: 0, length: attributedString.length)
        //Letter Spacing
        attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: range)

        //Font
        guard let font = UIFont(name: fontName, size: fontSize) else { return }
        attributedString.addAttribute(NSAttributedString.Key.font,
                                      value: font,
                                      range: NSRange(location: 0, length: attributedString.length))
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: textColor,
                                      range: NSRange(location: 0,
                                                     length: attributedString.length))

        self.attributedText = attributedString
        self.textAlignment = align

    }
    
    func resize() {
        
        //Record the origin transform
        let originTransform = self.transform
        
        self.transform = CGAffineTransform(rotationAngle: 0)
       
        var frame = self.frame
        
        let fixedWidth = frame.size.width
        
        // Calculate the biggest size that fixes in the given CGSize
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        frame.size = CGSize(width: fixedWidth, height: newSize.height)
        
        self.transform = originTransform
        
        self.bounds.size = frame.size
        
    }
}
