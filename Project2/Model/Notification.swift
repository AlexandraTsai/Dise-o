//
//  NotificationInfo.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/9.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

struct NotificationInfo {
    
    static let newText = ""
    static let newImage = UIImage()
    static let addImage = UIImage()
    static let editedImage = [UIView]()
    static let addingMode = true
    static let pickingPhotoMode = true
    static let backgroundIsImage = true
    static let changeImage = true
    static let didChangeImage = true
}

enum NotiName: String {
    
    case updateImage //After editing
    case addImage
    case changeBackground //Selected from album
    case addingMode //Add new element
    case pickingPhotoMode
    case changeImage //Change image at editingVC
    case didChangeImage
}