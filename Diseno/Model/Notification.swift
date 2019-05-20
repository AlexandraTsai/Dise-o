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
    static let takePhotoMode = true
    static let backgroundIsImage = true
    static let changeImageWithAlbum = true
    static let changeImageByCamera = true
    static let didChangeImage = true
    
    static let backgroundColor = "backgroundColor"  //UIColor
    
    static let addShape = ""
    static let paletteColor = "paletteColor"

    static let changeEditingViewColor = "changeEditingViewColor"
    static let addElementButton = true
    
    //Text attribute
    static let textTransparency = "textTransparency" //CGFloat
    static let textColor = "textColor" //UIColor
 
}

enum NotiName: String {
    
    case updateImage //After editing
    case addImage
    case changeBackground //Selected from album

    case backgroundColor
    
    case addingMode //Add new element
    case pickingPhotoMode
    case takePhotoMode
    case changeImageWithAlbum //Change image at editingVC
    case changeImageByCamera
    case didChangeImage
    case changeEditingViewColor
    
    //Shape
    case addShape
    case shapeColor
    
    //Palette
    case paletteColor
    
    //Button
    case addElementButton
    
    //Text Attribute
    case textTransparency
    case textColor
}