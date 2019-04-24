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
            designView.clipsToBounds = true
        }
        
    }
    
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var designNameLabel: UILabel!
    
    var btnTapAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    showMoreButton.setImage(ImageAsset.Icon_show_more.imageTemplate, for: .normal)
        
        showMoreButton.tintColor = UIColor.white
        showMoreButton.layer.cornerRadius = 8
        
    }

    @IBAction func showMoreBtnTapped(_ sender: Any) {
        
        btnTapAction?()
        
    }
    
}
