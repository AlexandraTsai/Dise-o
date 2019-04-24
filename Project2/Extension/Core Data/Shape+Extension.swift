//
//  Shape+Extension.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/24.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import CoreData
import UIKit

extension Shape {
    
    func transformShape(for designView: ALDesignView) {
        
        guard let shapeView = self.shapView as? ALShapeView else { return }
        
        if let shapeType = self.shapeType, let color = self.shapeColor as? UIColor {
            
            shapeView.shapeType = shapeType
            
            shapeView.shapeColor = color
            
            shapeView.stroke = self.stroke
            
        }
        
        designView.addSubview(shapeView)
    }
}
