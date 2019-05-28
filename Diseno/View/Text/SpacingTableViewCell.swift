//
//  SpacingTableViewCell.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/6.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

protocol SpacingTableViewCellDelegate: AnyObject {

    func changeTextAttributeWith(lineHeight: Float, letterSpacing: Float)

}

class SpacingTableViewCell: UITableViewCell {

    weak var delegate: SpacingTableViewCellDelegate?
    var lineHeight: Float = 0
    var letterSpace: Float = 0

    @IBOutlet weak var lineHeightLabel: UILabel!
    @IBOutlet weak var letterSpacingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func slideLineHeight(_ sender: UISlider) {

        lineHeight = sender.value
        delegate?.changeTextAttributeWith(lineHeight: sender.value, letterSpacing: letterSpace)

        lineHeightLabel.text = String(format: "%.1f", sender.value)

    }

    @IBAction func slideLetterSpacing(_ sender: UISlider) {

        letterSpace = sender.value
        delegate?.changeTextAttributeWith(lineHeight: lineHeight, letterSpacing: sender.value)

        letterSpacingLabel.text = String(format: "%.1f", sender.value)
    }
}
