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
    
    func changeText() {
        
        var newText = ""
        newText.append(self.text)
        
        guard let originalText = originalText else { return }
            
        if newText.count > 0 {
                
            switch newText.count > (originalText.count) {
            
            case true:
            
                var number = 1
                
                for character in newText {
                    
                    let index = originalText.index(originalText.startIndex, offsetBy: number-1)
                    
                    if number > originalText.count {
                        
                        self.originalText?.append(character)

                    } else {
                        
                        let oldChar = originalText[index]
                    
                        if character != oldChar {
                            
                            self.originalText?.insert(character, at: index)
                            
                        } else {
                            
                            number += 1
                        }
                       
                    }
                }

            case false:
                
                var number = 1
                
                for character in originalText {
                    
                    let index = newText.index(originalText.startIndex, offsetBy: number-1)
                    
                    if number > newText.count {
                        
                        self.originalText?.removeLast()
                        
                    } else {
                        
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

        if upperCase {
            
            self.text = self.text?.uppercased()
            
        } else {
            
            self.text = self.originalText
        }
        
        self.resize()
        
    }
}
