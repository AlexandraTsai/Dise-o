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
    case baskerville = "Baskerville"
    case chalkboardSE = "Chalkboard SE"
    case chalkduster = "ChalkboardSE-Regular"
    case charter
    case cochin
    case copperplate
    case courier
    case damascus
    case didot
    case dINAlternate = "DIN Alternate"
    case dINCondensed = "DIN Condensed"
    case euphemiaUCAS = "EuphemiaUCAS"
    case farah
    case futura
    case geezaPro = "GeezaPro"
    case georgia
    case gillSans = "Gill Sans"
    case gurmukhiMN = "Gurmukhi MN"
    case helveticaNeue = "Helvetica Neue"
    case hoeflerText = "HoeflerText-Regular"
    case kailasa = "Kailasa"
    case kefa
    case markerFelt = "Marker Felt"
    case menloRegular = "Menlo-Regular"
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
        case .alNile, .copperplate, .chalkboardSE, .damascus, .geezaPro, .gurmukhiMN, .kailasa:
            return 1

        //italic
        case .hoeflerText:
            return 2

        //bold, italic
        case .didot, .euphemiaUCAS:
            return 3

        //bold, italic, boldItalic
        case .arialMT, .cochin, .baskerville, .georgia, .gillSans, .helveticaNeue, .menloRegular, .palatino:
            return 4
        default:
            return 0
        }
    }
    // swiftlint:disable cyclomatic_complexity
    func boldStyle() -> String {

        switch self {
        case .alNile:
            return "AlNile-Bold"
        case .arialMT:
            return "Arial-BoldMT"
        case .baskerville:
            return "Baskerville-Bold"
        case .damascus:
            return "DamascusBold"
        case .didot:
            return "Didot-Bold"
        case .copperplate:
            return "Copperplate-Bold"
        case .chalkboardSE:
            return "ChalkboardSE-Bold"
        case .cochin:
            return  "Cochin-Bold"
        case .euphemiaUCAS:
            return "EuphemiaUCAS-Bold"
        case .geezaPro:
            return "GeezaPro-Bold"
        case .georgia:
            return "Georgia-Bold"
        case .gillSans:
            return "GillSans-Bold"
        case .gurmukhiMN:
            return "GurmukhiMN-Bold"
        case .helveticaNeue:
            return "HelveticaNeue-Bold"
        case .kailasa:
            return "Kailasa-Bold"
        case .menloRegular:
            return "Menlo-Bold"
        case .palatino:
            return  "Palatino-Bold"
        default:
            return self.rawValue
        }
    }

    func italicStyle() -> String {

        switch self {
        case .arialMT: return "Arial-ItalicMT"
        case .baskerville: return "Baskerville-Italic"
        case .cochin: return  "Cochin-Italic"
        case .didot: return "Didot-Italic"
        case .euphemiaUCAS: return "EuphemiaUCAS-Italic"
        case .georgia: return "Georgia-Italic"
        case .gillSans: return "GillSans-Italic"
        case .helveticaNeue: return "HelveticaNeue-Italic"
        case .hoeflerText: return "HoeflerText-Italic"
        case .menloRegular: return "Menlo-Italic"
        case .palatino: return  "Palatino-Italic"
        default: return self.rawValue
        }
    }
    func boldItalicStyle() -> String {

        switch self {
        case .arialMT: return "Arial-BoldItalicMT"
        case .baskerville: return "Baskerville-BoldItalic"
        case .cochin: return  "Cochin-BoldItalic"
        case .georgia: return "Georgia-BoldItalic"
        case .gillSans: return "GillSans-BoldItalic"
        case .helveticaNeue: return "HelveticaNeue-BoldItalic"
        case .menloRegular: return "Menlo-BoldItalic"
        case .palatino: return  "Palatino-BoldItalic"
        default: return self.rawValue
        }
    }
    
     // swiftlint:enable cyclomatic_complexity
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
