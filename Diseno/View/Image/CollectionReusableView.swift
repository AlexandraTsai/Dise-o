//
//  CollectionReusableView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/3.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var cameraRollBtn: UIButton!

    @IBOutlet weak var colorsBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        cameraRollBtn.isSelected = true
        changeBtnHighlight()
    }

    @IBAction func cameraRollBtnTapped(_ sender: Any) {

        cameraRollBtn.isSelected = true
        changeBtnHighlight()

    }

    @IBAction func colorsBtnTapped(_ sender: Any) {

        colorsBtn.isSelected = true
        changeBtnHighlight()
    }

    func changeBtnHighlight() {

        if cameraRollBtn.isSelected {

            cameraRollBtn.isSelected = false
            cameraRollBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            colorsBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        } else {

            colorsBtn.isSelected = false
            cameraRollBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            colorsBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }
    }
}
