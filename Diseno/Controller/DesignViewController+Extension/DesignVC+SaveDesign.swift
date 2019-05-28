//
//  DesignVC+SaveDesign.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/13.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

extension DesignViewController {
    
    func prepareForSaving() {
        
        let count = designView.subviews.count
        
        for index in 0..<count {
            
            let subViewToAdd = designView.subviews[index]
            
            if let imageView = subViewToAdd as? ALImageView {
                
                imageView.index = index
                
                designView.subImages.append(imageView)
                
            } else if let textView = subViewToAdd as? ALTextView {
                
                textView.index = index
                
                designView.subTexts.append(textView)
                
            } else if let shapeView = subViewToAdd as? ALShapeView {
                
                shapeView.index = index
                
                designView.subShapes.append(shapeView)
            }
        }
    }
    
}
