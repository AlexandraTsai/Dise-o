//
//  HomePageViewModel.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/7/18.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol HomePageViewModelInput {
    var newDesignName: BehaviorRelay<String?> { get }
    
    func createNewDesign()
}

protocol HomePageViewModelOutput {
    var designs: BehaviorRelay<[PortfolioCellViewModel]> { get }
}

typealias HomePageViewModelPrototype = HomePageViewModelInput & HomePageViewModelOutput

class HomePageViewModel: HomePageViewModelPrototype {
    // MARK: Output
    let designs = BehaviorRelay<[PortfolioCellViewModel]>(value: [])

    // MARK: HomePageViewModelInput
    let newDesignName = BehaviorRelay<String?>(value: nil)

    func createNewDesign() {
        coordinator.goDesignPage()
    }
    
    init(coordinator: AppCoordinatorPrototype) {
        self.coordinator = coordinator
        fetchDesign()
    }

    private let storageManager = StorageManager.shared
    private let coordinator: AppCoordinatorPrototype
}

private extension HomePageViewModel {
    func fetchDesign() {
        storageManager.fetchDesigns(completion: { result in
            guard case let .success(design) = result else {
                print("fetch design failed")
                return
            }
            self.designs.accept(design.map { PortfolioCellViewModel(design: $0) })
        })
    }
}
