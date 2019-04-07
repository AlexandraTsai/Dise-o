//
//  UIFont+Extension.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/6.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

enum FontName: String, CaseIterable {
    case AcademyEngravedLet = "Academy Engraved LET"
    case Arial
    case Avenir
    case AvenirNextCondensed = "Avenir Next Condensed"
    case ChalkboardSE = "Chalkboard SE"
    case Chalkduster
    case Charter
    case Cochin
    case Copperplate
    case Courier
    case Damascus
    case Didot
    case DINAlternate = "DIN Alternate"
    case DINCondensed = "DIN Condensed"
    case Farah
    case Futura
    case Georgia
    case GillSans = "Gill Sans"
    case GurmukhiMN = "Gurmukhi MN"
    case HelveticaNeue = "Helvetica Neue"
    case HoeflerText = "Hoefler Text"
    case Kailasa = "Kailasa"
    case Kefa
    case MarkerFelt = "Marker Felt"
    case Noteworthy
    case OriyaSangamMN = "Oriya Sangam MN"
    case Palatino
    case Papyrus
    case PartyLET = "Party LET"
    case Rockwell
    case SavoyeLet = "Savoye LET"
    
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
