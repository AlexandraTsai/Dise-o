//
//  PortfolioCollectionViewCell.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/21.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

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
    
    var btnTapAction: (() -> Void)?

    func config(viewModel: PortfolioCellViewModel) {
        designView.image = viewModel.portfolio.image
        designNameLabel.text = viewModel.portfolio.name
    }

    @IBAction func showMoreBtnTapped(_ sender: Any) {
        btnTapAction?()
    }
}
