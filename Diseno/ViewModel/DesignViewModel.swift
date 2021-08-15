//
//  DesignViewModel.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/8/10.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit

protocol DesignCoordinator: AnyObject {
    func designDone()
}

protocol DesignViewModelInput {
    func saveDesign(_ design: ALDesignView)
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
    func saveDesign(_ design: ALDesignView) {
        let date = Date().timeIntervalSince1970
        let fileName = "Screenshot_\(date)"
        let screenshot = design.takeScreenshot()

        design.screenshotName = fileName
        fileManager.saveImage(fileName: fileName, image: screenshot)

        switch entry {
        case .new:
            storageManager.saveDesign(newDesign: design, createTime: Int64(date), completion: { result in
                switch result {
                case .success:
                    print("Save success.")
                case .failure:
                    print("Fail to save")
                }
            })
        case let .editing(oldDesign):
            StorageManager.shared.updateDesign(
                design: design,
                createTime: oldDesign.createTime,
                completion: { result in
                    switch result {
                    case .success:
                        StorageManager.shared.deleteSubElement(completion: { result in
                            switch result {
                            case .success:
                                print("Success to delete unused data")
                            case .failure:
                                print("Fail to delete unused data")
                            }
                        })
                    case .failure:
                        print("Fail to save")
                    }
            })
        }
        coordinator?.designDone()
    }

    init(entry: DesignEntry,
         fileManager: DSFileManager,
         storageManager: StorageManager,
         coordinator: DesignCoordinator?) {
        self.entry = entry
        self.fileManager = fileManager
        self.storageManager = storageManager
        self.coordinator = coordinator
    }

    private let fileManager: DSFileManager
    private let storageManager: StorageManager
    private weak var coordinator: DesignCoordinator?
}
