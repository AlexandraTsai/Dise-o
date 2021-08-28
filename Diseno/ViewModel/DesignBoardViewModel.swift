//
//  DesignBoardViewModel.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/8/28.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum FocusType {
    case container
    case text
    case image
    case shape
    case none

    var tools: [Tool] {
        switch self {
        case .container: return [.color]
        case .text: return [.color, .duplicate, .delete]
        case .image:  return [.color, .filter, .duplicate, .delete]
        case .shape: return [.color, .duplicate, .delete]
        case .none:  return []
        }
    }
}

enum Tool {
    case color
    case duplicate
    case delete
    case filter
    case font

    var icon: UIImage {
        switch self {
        case .color:     return #imageLiteral(resourceName: "Icon_color")
        case .duplicate: return #imageLiteral(resourceName: "Icon_Copy")
        case .delete:    return #imageLiteral(resourceName: "Icon_TrashCan")
        case .filter:    return #imageLiteral(resourceName: "Icon_filter")
        case .font:      return #imageLiteral(resourceName: "Icon_text")
        }
    }
}

protocol DesignBoardViewModelInput: AnyObject {
    func onFucus(_ type: FocusType)
}

protocol DesignBoardViewModelOutput: AnyObject {
    var focusType: BehaviorRelay<FocusType> { get }
}

typealias DesignBoardViewModelProtocol = DesignBoardViewModelInput & DesignBoardViewModelOutput

class DesignBoardViewModel: DesignBoardViewModelProtocol {
    let focusType = BehaviorRelay<FocusType>(value: .none)

    func onFucus(_ type: FocusType) {
        focusType.accept(type)
    }
}
