//
//  FilterType.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/4.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import Foundation

enum FilterType: String, CaseIterable {
    
    case chrome = "CIPhotoEffectChrome"
    case fade = "CIPhotoEffectFade"
    case tone = "CISepiaTone"
    case instant = "CIPhotoEffectInstant"
    case mono = "CIPhotoEffectMono"
    case noir = "CIPhotoEffectNoir"
    case process = "CIPhotoEffectProcess"
    case tonal = "CIPhotoEffectTonal"
    case transfer =  "CIPhotoEffectTransfer"
    case colorControl = "CIFalseColor"
    
}
