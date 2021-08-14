//
//  DesignViewModel.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/8/10.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import Foundation

protocol DesignCoordinator: AnyObject {
    func designDone()
}

protocol DesignViewModelInput {
    func finishDesign()
}

protocol DesignViewModelOutput {
    var entry: DesignEntry { get }
}

typealias DesignViewModelProtocol = DesignViewModelInput & DesignViewModelOutput

enum DesignEntry {
    case new
    case editing(Design)
}

class DesignViewModel: DesignViewModelProtocol {
    // MARK: DesignViewModelOutput
    let entry: DesignEntry

    // MARK: DesignViewModelInput
    func finishDesign() {
        coordinator?.designDone()
    }

    init(entry: DesignEntry, coordinator: DesignCoordinator?) {
        self.entry = entry
        self.coordinator = coordinator
    }

    private weak var coordinator: DesignCoordinator?
}
