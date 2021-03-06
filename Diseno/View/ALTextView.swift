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
    
    func makeACopy() -> ALTextView {
        
        let newView = ALTextView()
       
        newView.inputView = self.inputView
        newView.textContainer.size = self.textContainer.size
        newView.frame = self.frame
        newView.transform = self.transform
        
        newView.backgroundColor = self.backgroundColor
        newView.alpha = self.alpha
        
        newView.text = self.text
        newView.font = self.font
        newView.textColor = self.textColor
        newView.textAlignment = self.textAlignment
        
        newView.originalText = self.originalText
        newView.upperCase = self.upperCase
        
        return newView
    }

    func fixOriginalText() {
        
        guard let originalText = originalText, let newText = self.text else { return }
            
        if newText.count > 0 {
                
            switch newText.count > (originalText.count) {
            
            case true:
            
                print(originalText)
                insertCharacter(to: originalText, accordingTo: newText)
                
            case false:
                
                removeCharacter(of: originalText, accordingTo: newText)
            }
            
        } else {
            
            self.originalText = ""
            
        }

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
                let oldCharacter2 = originalText.uppercased()[index]
                
                if character != oldCharacter && character != oldCharacter2 {
                    
                    self.originalText?.insert(character, at: index)
                    
                } else {
                    
                    number += 1
                }
            }
        }
   
    }
    
    func removeCharacter(of originalText: String, accordingTo newText: String) {
        
        var number = 1
        
        for _ in originalText {
            
            if number > newText.count {
                
                self.originalText?.removeLast()
                
            } else {
                
                let index = newText.index(originalText.startIndex, offsetBy: number-1)
                
                let oldCharacter = originalText.uppercased()[index]
                
                let newCharacter2 = newText.uppercased()[index]
                
                if oldCharacter != newCharacter2 {
                    
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
