//
//  Text+Extension.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/24.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit
import CoreData

extension Text {
    
    func transformText(for designView: ALDesignView) {
        
        guard let frame = self.frame as? CGRect,
            let transform = self.transform as? CGAffineTransform,
            let attributedText = self.attributedText as? NSAttributedString else { return }
        
        let textView = ALTextView()
        
        textView.frame = frame
        
        textView.transform = transform
        
        textView.attributedText = attributedText
        
        textView.originalText = originalText
        
        textView.upperCase = upperCase
        
        textView.backgroundColor = UIColor.clear
        
        textView.index = Int(self.index)
        
        designView.subTexts.append(textView)
        
        designView.addSubview(textView)
    }
   
}

extension Text: LayerProtocol {
    
    func mapping(_ object: ALTextView) {
        
        if object.text != nil {
            
            guard let textToSave = object.attributedText else { return }
            
            attributedText = textToSave as NSObject
        }
        
        originalText = object.originalText
        
        upperCase = object.upperCase
        
        textContainerSize = object.textContainer.size as NSObject
        
        transform = object.transform as NSObject
        
        object.transform = CGAffineTransform(rotationAngle: 0)
        
        frame = object.frame as NSObject
        
        guard let objectIndex = object.index else { return }
        
        index = Int16(objectIndex)
    }
}
