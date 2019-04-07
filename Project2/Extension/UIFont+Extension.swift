//
//  UIFont+Extension.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/6.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

enum FontName: String, CaseIterable {
    
    case academyEngravedLet = "Academy Engraved LET"
    case alNile = "AlNile"
    case arialMT = "ArialMT"
    case avenir
    case avenirNextCondensed = "Avenir Next Condensed"
    case chalkboardSE = "Chalkboard SE"
    case chalkduster
    case charter
    case cochin
    case copperplate
    case courier
    case damascus
    case didot
    case dINAlternate = "DIN Alternate"
    case dINCondensed = "DIN Condensed"
    case farah
    case futura
    case georgia
    case gillSans = "Gill Sans"
    case gurmukhiMN = "Gurmukhi MN"
    case helveticaNeue = "Helvetica Neue"
    case hoeflerText = "HoeflerText-Regular"
    case kailasa = "Kailasa"
    case kefa
    case markerFelt = "Marker Felt"
    case noteworthy
    case oriyaSangamMN = "Oriya Sangam MN"
    case palatino
    case papyrus
    case partyLET = "Party LET"
    case rockwell
    case savoyeLet = "Savoye LET"
    
    func fontStyle() -> Int {
        
        switch self {
            
        //bold
        case .alNile, .copperplate:
            return 1
        
        //italic
        case .hoeflerText:
            return 2
            
        //bold, italic, boldItalic
        case .arialMT, .cochin:
            return 4
        default:
            return 0
        }
    }
    
    func boldStyle() -> String {
      
        switch self {
        case .alNile:
            return "AlNile-Bold"
        case .arialMT:
            return "Arial-BoldMT"
        default:
            return "Copperplate-Bold"
        }
    }
    
}

enum FontNameForBold: String {
    
    case alNil = "AlNile-Bold"
    case arialMT = "Arial-BoldMT"
    case copperplate = "Copperplate-Bold"
}

enum FontNameForItalic: String {
    
    case arialMT = "Arial-ItalicMT"
    case hoeflerText = "HoeflerText-Italic"
}

enum FontNameForBoldItalic: String {
    
    case arialMT = "Arial-BoldItalicMT"
    case cochin = "Cochin-BoldItalic"
}

extension UIFont {
    
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
