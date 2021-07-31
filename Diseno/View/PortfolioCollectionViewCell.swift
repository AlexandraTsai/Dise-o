//
//  PortfolioCollectionViewCell.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/21.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PortfolioCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var designView: UIImageView! {
        didSet {
            designView.layer.cornerRadius = 20
            designView.layer.borderWidth = 1
            designView.layer.borderColor = UIColor.DSColor.lightGreen.cgColor
            designView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var showMoreButton: UIButton! {
        didSet {
            showMoreButton.setImage(ImageAsset.Icon_show_more.imageTemplate, for: .normal)
            showMoreButton.tintColor = UIColor.white
            showMoreButton.layer.cornerRadius = 8
        }
    }

    @IBOutlet weak var designNameLabel: UILabel! {
        didSet {
            designNameLabel.font = UIFont(name: FontName.futura.rawValue, size: 16)
        }
    }

    func config(viewModel: PortfolioCellViewModel) {
        bind(viewModel)
    }

    private weak var viewModel: PortfolioCellViewModel?
    private var disposeBag = DisposeBag()
}

private extension PortfolioCollectionViewCell {
    func bind(_ viewModel: PortfolioCellViewModel) {
        disposeBag = DisposeBag()
        self.viewModel = viewModel

        designView.image = viewModel.portfolio.image
        designNameLabel.text = viewModel.portfolio.name

        showMoreButton.rx.tap
            .bind(to: viewModel.showPortfolioAction)
            .disposed(by: disposeBag)
    }
}
