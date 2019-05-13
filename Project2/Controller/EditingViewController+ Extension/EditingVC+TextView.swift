//
//  EditingVC+TextView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/13.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

extension EditingViewController: TextContainerDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        guard let textView = textView as? ALTextView else { return }
        
        textView.fixOriginalText()
        
        helperView.resize(accordingTo: textView)
        
    }
    
    func changeTextWith(lineHeight: Float, letterSpacing: Float) {
        
        guard let view = editingView as? ALTextView,
            let fontName = view.font?.fontName,
            let fontSize = view.font?.pointSize,
            let textColor = view.textColor else { return }
        
        view.lineHeight = lineHeight
        view.letterSpacing = letterSpacing
        
        view.keepAttributeWith(lineHeight: lineHeight,
                               letterSpacing: letterSpacing,
                               fontName: fontName,
                               fontSize: fontSize,
                               textColor: textColor)
        view.resize()
        
        helperView.resize(accordingTo: view)
        
    }
    
    func changeFont(to size: Int) {
        
        guard let view = editingView as? ALTextView,
            let fontName = view.font?.fontName,
            let textColor = view.textColor else { return }
        
        view.keepAttributeWith(lineHeight: view.lineHeight,
                               letterSpacing: view.letterSpacing,
                               fontName: fontName,
                               fontSize: CGFloat(size),
                               textColor: textColor)
        
        view.font = UIFont(name: fontName, size: CGFloat(size))
        
        view.resize()
        
        createEditingHelper(for: view)
        
        textContainerVC?.fontSizeButton.setTitle(String(size), for: .normal)
    }
    
    
    func alignmentChange(to type: NSTextAlignment) {
        
        guard let view =  editingView as? ALTextView else { return }
        view.textAlignment = type
        
    }
    
    func changeLetterTo(upperCase: Bool) {
        
        guard let view =  editingView as? ALTextView,
            let fontName = view.font?.fontName,
            let fontSize = view.font?.pointSize,
            let textColor = view.textColor else { return }
        
        if upperCase {
            
            view.text = view.originalText?.uppercased()
            view.upperCase = true
            
        } else {
            
            view.text = view.originalText
            view.upperCase = false
        }
        
        view.keepAttributeWith(lineHeight: view.lineHeight,
                               letterSpacing: view.letterSpacing,
                               fontName: fontName,
                               fontSize: fontSize,
                               textColor: textColor)
        view.resize()
    }
    
    func changeFont(to font: UIFont) {
        
        guard let textView = editingView as? UITextView else { return }
        
        textView.font = font
        
    }
    
    func changeFont(to fontName: FontName) {
        
        guard let view = editingView as? ALTextView,
            let fontSize = view.font?.pointSize else { return }
        
        view.font = UIFont(name: fontName.rawValue, size: fontSize)
        
        view.resize()
    }
    
    func textTransparency(value: CGFloat) {
        
        guard let textView = editingView as? ALTextView else { return }
        
        let color = textView.textColor
        
        textView.textColor = color?.withAlphaComponent(value)
        
    }
    
    func textColorChange(to color: UIColor) {
        
        guard let textView = editingView as? ALTextView else { return }
        
        guard let alpha = textView.textColor?.cgColor.alpha else { return }
        
        textView.textColor = color.withAlphaComponent(alpha)
        
    }
        
}
