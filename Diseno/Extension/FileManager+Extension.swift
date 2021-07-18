//
//  FileManager+Extension.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/7/18.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit

extension FileManager {
    static func loadImageFromDisk(fileName: String) -> UIImage? {
        let documentDirectory = SearchPathDirectory.documentDirectory
        let userDomainMask = SearchPathDomainMask.userDomainMask
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
