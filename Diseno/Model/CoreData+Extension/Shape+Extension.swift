//
//  Shape+Extension.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/24.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import CoreData
import UIKit

protocol LayerProtocol {
    var index: Int16 { get set }
}

extension Shape {
    
    func transformShape(for designView: ALDesignView) {
        
        guard let shapeView = self.shapView as? ALShapeView else { return }
        
        if let shapeType = self.shapeType, let color = self.shapeColor as? UIColor {
            
            shapeView.shapeType = shapeType
            
            shapeView.shapeColor = color
            
            shapeView.stroke = self.stroke
            
        }
        
        shapeView.index = Int(self.index)
        
        designView.subShapes.append(shapeView)
        
        designView.addSubview(shapeView)
    }
}

extension Shape: LayerProtocol {
    
    func mapping(_ object: ALShapeView) {
        
        shapView = object
        
        shapeType = object.shapeType
        
        shapeColor = object.shapeColor
        
        stroke = object.stroke
        
        guard let objectIndex = object.index else { return }
        
        index = Int16(objectIndex)
        
    }
}
