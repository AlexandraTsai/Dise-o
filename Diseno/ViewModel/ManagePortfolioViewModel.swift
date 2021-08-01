//
//  PortfolioManageViewModel.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/7/27.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit

enum PortfolioManageType: CaseIterable {
    case open
    case download
    case share
    case rename
    case delete
}

protocol ManagePortfolioViewModelInput: AnyObject {
    func receiveAction(_ actionType: PortfolioManageType)
}

typealias ManagePortfolioViewModelPrototype = ManagePortfolioViewModelInput
