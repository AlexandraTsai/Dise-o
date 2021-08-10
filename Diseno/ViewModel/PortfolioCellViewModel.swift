//
//  PortfolioCellViewModel.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/7/18.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

struct Portfolio {
    var image: UIImage?
    let name: String
}

protocol PortfolioCellViewModelOutput {
    var design: Design { get }
    var portfolio: Portfolio { get }
}

protocol PortfolioCellViewModelInput {
    var showPortfolioAction: PublishRelay<Void> { get }
}

typealias PortfolioCellViewModelPrototype = PortfolioCellViewModelOutput & PortfolioCellViewModelInput

class PortfolioCellViewModel: PortfolioCellViewModelPrototype {
    // MARK: PortfolioCellViewModelOutput
    let design: Design
    var portfolio = Portfolio(image: nil, name: "")

    // MARK: PortfolioCellViewModelInput
    let showPortfolioAction = PublishRelay<Void>()

    init(design: Design, parent: HomePageViewModelInput) {
        self.design = design
        self.parent = parent

        guard let designName = design.designName,
              let screeshot = design.screenshot else { return }
        portfolio = Portfolio(image: FileManager.loadImageFromDisk(fileName: screeshot), name: designName)

        showPortfolioAction
            .bind {
                parent.showPortfoliAction(for: design)
            }.disposed(by: disposeBag)
    }

    private weak var parent: HomePageViewModelInput?
    private let disposeBag = DisposeBag()
}
