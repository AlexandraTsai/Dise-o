//
//  RenameDesignViewModel.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/8/10.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol RenameDesignViewModelInput: AnyObject {
    func rename()
}

protocol RenameDesignViewModelOutput {
    var designName: BehaviorRelay<String?> { get }
}

typealias RenameDesignViewModelPrototype = RenameDesignViewModelInput & RenameDesignViewModelOutput

class RenameDesignViewModel: RenameDesignViewModelPrototype {
    let designName: BehaviorRelay<String?>

    func rename() {
        let newName = designName.value ?? ""
        design.designName = newName
        StorageManager.shared.renameDesign(design: design,
                                           name: newName,
                                           createTime: design.createTime,
                                           completion: { result in

            switch result {
            case .success:
                parent?.updateDesign()
            case .failure:
                print("Fail to rename")
            }
        })
    }

    init(design: Design, storeManager: StorageManager, parent: HomePageViewModelInput?) {
        self.designName = BehaviorRelay<String?>(value: design.designName)
        self.design = design
        self.storeManager = storeManager
        self.parent = parent
    }

    private let design: Design
    private let storeManager: StorageManager
    private weak var parent: HomePageViewModelInput?
}
