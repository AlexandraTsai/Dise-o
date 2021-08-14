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
        guard let frame = frame as? CGRect,
            let designName = designName,
            let screeshot = screenshot else { return }
        
        designView.frame = frame
        designView.createTime = createTime
        designView.designName = designName
        designView.screenshotName = screeshot
        
        if let filter = filter {
            for type in FilterType.allCases where type.rawValue == filter {
                designView.filterName = type
            }
        }
        
        if let color = backgroundColor as? UIColor {
            designView.backgroundColor = color
        }
        
        if let bgImageName = backgroundImage {
            let backgroundImage = loadImageFromDiskWith(fileName: bgImageName)
            designView.image = backgroundImage
            designView.imageFileName = bgImageName
        }

        // Subview: Images, TextView, ShapeView
        var layer = [LayerProtocol]()

        [images, texts, shapes].forEach {
            guard let set = $0, let arr = Array(set) as? [LayerProtocol] else { return }
            layer.append(contentsOf: arr)
        }

        layer.sort { $0.index < $1.index }

        layer.forEach {
            switch $0 {
            case is Image:
                ($0 as! Image).transformImage(for: designView)
            case is Text:
                ($0 as! Text).transformText(for: designView)
            case is Shape:
                ($0 as! Shape).transformShape(for: designView)
            default:
                break
            }
        }
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory,
                                                        userDomainMask,
                                                        true)
        guard let dirPath = paths.first else {
            return nil
        }
        let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
        let image = UIImage(contentsOfFile: imageUrl.path)
        return image
    }
}
