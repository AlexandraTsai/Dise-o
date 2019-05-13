//
//  DesignVC+AddText.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/13.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

extension DesignViewController {
    
    func addingTextMode() {
        
        //Hide NavigationBar
        navigationController?.navigationBar.isHidden = true
        textView.isHidden = false
        textView.becomeFirstResponder()
        
        textView.text = "Enter your text"
        textView.delegate = self
        
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.endOfDocument)
    }
    
    func notAddingTextMode() {
        
        navigationController?.navigationBar.isHidden = false
        textView.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let newText = addTextView()
        
        notAddingTextMode()
        
        goToEditingVC(with: newText, navigationBarForImage: false)
        
    }

    func addTextView() -> ALTextView {
        
        let contentSize = self.textView.sizeThatFits(self.textView.bounds.size)
        
        let newText = ALTextView(
            frame: CGRect(x: textView.frame.origin.x-designView.frame.origin.x,
                          y: textView.frame.origin.y-designView.frame.origin.y,
                          width: textView.frame.width,
                          height: contentSize.height))
        
        newText.text = textView.text
        newText.originalText = newText.text
        newText.font = textView.font
        newText.backgroundColor = UIColor.clear
        newText.textAlignment = textView.textAlignment
        newText.textColor = UIColor.black
        newText.isScrollEnabled = false
        
        newText.addDoneButtonOnKeyboard()
        
        addAllGesture(to: newText)
        
        designView.addSubview(newText)
        
        return newText
    }

    @objc func endEditing(_ sender: UITapGestureRecognizer) {
        
        hintView.isHidden = false
        addElementView.isHidden = true
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            
            self?.addButton.transform = CGAffineTransform.init(rotationAngle: 0)
            
        }
        
    }

}
