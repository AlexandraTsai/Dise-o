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
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var designView: UIImageView! {
        didSet {
            designView.layer.cornerRadius = cornerRadius
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

    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
    }

    func config(viewModel: PortfolioCellViewModel) {
        bind(viewModel)
        addShadow()
    }

    private let cornerRadius: CGFloat = 20
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

    func addShadow() {
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: cornerRadius).cgPath
        shadowView.layer.cornerRadius = 20
        shadowView.layer.shadowColor = UIColor.gray.cgColor
        shadowView.layer.shadowRadius = 15.0
        shadowView.layer.shadowOpacity = 0.3
    }
}
