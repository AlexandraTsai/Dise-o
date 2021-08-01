//
//  FileManager.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/7/31.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit


class DSFileManager {
    static func loadImageFromDiskWith(fileName: String) -> UIImage? {
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
