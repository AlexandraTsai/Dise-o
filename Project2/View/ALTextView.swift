//
//  ALTextView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/22.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class ALTextView: UITextView {
    
    var index: Int?
    
    var originalText: String? = ""
    
    var upperCase: Bool = false
    
    func makeACopy(from oldView: ALTextView) {
       
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
        
        self.originalText = oldView.originalText
        self.upperCase = oldView.upperCase
    }
    
    func changeText(){
        
        var newText = ""
        newText.append(self.text)
        
        guard let originalText = originalText else { return }
            
        if newText.count > 0 {
                
            switch newText.count > (originalText.count) {
            
            case true:
                    
            //Remove the text that original text already has
                if originalText.count != 0 {
                        
                for _ in 1...originalText.count {
                            
                    newText.removeFirst()
                            
                }
            }
                    
                self.originalText?.append(newText)
                    
            default:
                    
                let count = originalText.count - newText.count
                    
                for _ in  1...count {
                        
                    self.originalText?.removeLast()
                }
            }
        }

        if upperCase {
            
            self.text = self.originalText?.uppercased()
            
        } else {
            
            self.text = self.originalText
        }
        
        self.resize()
        
    }
}
