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
    
    var lineHeight: Float = 0
    
    var letterSpacing: Float = 0
    
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
    
    func fixOriginalText() {
        
        guard let originalText = originalText, let newText = self.text else { return }
            
        if newText.count > 0 {
                
            switch newText.count > (originalText.count) {
            
            case true:
            
                insertCharacter(to: originalText, accordingTo: newText)
                
            case false:
                
                removeCharacter(of: originalText, accordingTo: newText)
            }
            
        } else { self.originalText = "" }

        changeText()
        
        self.resize()
        
    }
    
    func changeText() {
        
        if upperCase {
            
            self.text = self.originalText?.uppercased()
            
        } else {
            
            self.text = self.originalText
        }
        
    }
    
    func insertCharacter(to originalText: String, accordingTo newText: String) {
        
        var number = 1
        
        for character in newText {
            
            if number > originalText.count {
                
                self.originalText?.append(character)
                
            } else {
                
                let index = originalText.index(originalText.startIndex, offsetBy: number-1)
                
                let oldCharacter = originalText[index]
                
                if character != oldCharacter {
                    
                    self.originalText?.insert(character, at: index)
                    
                } else {
                    
                    number += 1
                }
            }
        }
   
    }
    
    func removeCharacter(of originalText: String, accordingTo newText: String) {
        var number = 1
        
        for character in originalText {
            
            if number > newText.count {
                
                self.originalText?.removeLast()
                
            } else {
                
                let index = newText.index(originalText.startIndex, offsetBy: number-1)
                
                let newChar = newText[index]
                
                if character != newChar {
                    
                    self.originalText?.remove(at: index)
                    
                } else {
                    
                    if number < originalText.count {
                        number += 1
                    }
                    
                }
            }
            
        }
    }
}
