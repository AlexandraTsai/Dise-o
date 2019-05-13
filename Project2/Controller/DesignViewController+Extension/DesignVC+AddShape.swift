//
//  DesignVC+AddShape.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/13.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

extension DesignViewController: ShapeContainerVCDelegate {
    
    func addShape(with shapeType: String) {
        
        let newShape = ALShapeView(frame: CGRect(x: designView.frame.width/2-75,
                                                 y: designView.frame.height/2-75,
                                                 width: 150,
                                                 height: 150))
        
        newShape.shapeType = shapeType
        
        for shape in ShapeAsset.allCases where shape.rawValue == shapeType {
            
            let border = shape.shapeBorderOnly()
            
            if border {
                
                newShape.stroke =  true
                
            } else {
                
                if designView.image == nil && designView.backgroundColor == UIColor.white {
                    
                    newShape.shapeColor = UIColor.init(red: 221/255, green: 221/255, blue: 221/255, alpha: 1)
                }
            }
        }
        
        designView.addSubview(newShape)
        addAllGesture(to: newShape)
        
        goToEditingVC(with: newShape, navigationBarForImage: false)
        
    }
    
}
