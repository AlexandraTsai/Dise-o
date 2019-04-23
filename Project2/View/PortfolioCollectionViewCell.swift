//
//  PortfolioCollectionViewCell.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/21.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class PortfolioCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var designView: UIImageView!
    @IBOutlet weak var showMoreButton: UIButton!
    
    var btnTapAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    showMoreButton.setImage(ImageAsset.Icon_show_more.imageTemplate, for: .normal)
        
        showMoreButton.tintColor = UIColor.white
        showMoreButton.layer.cornerRadius = 8
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 20
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 20
    }
    
    @IBAction func showMoreBtnTapped(_ sender: Any) {
        
        btnTapAction?()
        
    }
    
}
