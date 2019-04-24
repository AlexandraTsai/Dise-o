//
//  Design+Extension.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/24.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit
import CoreData

extension Design {
    
    func transformDesign(for designView: ALDesignView) {
        
        guard let frame = self.frame as? CGRect,
            let designName = self.designName,
            let screeshot = self.screenshot else { return }
        
        designView.frame = frame
        
        designView.createTime = self.createTime
        
        designView.designName = designName
        
        designView.screenshotName = screeshot
        
        if self.backgroundColor != nil {
            
            guard let color = self.backgroundColor as? UIColor else { return }
            
            designView.backgroundColor = color
            
        }
        
        if self.backgroundImage != nil {
            
            guard let fileName = self.backgroundImage else { return }
            
            let backgroundImage = loadImageFromDiskWith(fileName: fileName)
            
            designView.image = backgroundImage
            
            designView.imageFileName = fileName
            
        }
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory,
                                                        userDomainMask,
                                                        true)
        
        if let dirPath = paths.first {
            
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            
            let image = UIImage(contentsOfFile: imageUrl.path)
            
            return image
            
        }
        
        return nil
    }
}
