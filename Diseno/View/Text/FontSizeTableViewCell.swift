//
//  FontSizeTableViewCell.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/6.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

protocol FontSizeTableViewCellDelegate: AnyObject {

    func changeFontSize(to size: Int)
}

class FontSizeTableViewCell: UITableViewCell {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var fontSizeLabel: UILabel!

    weak var delegate: FontSizeTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func sliderDidSlide(_ sender: UISlider) {

        let fontSize = Int(sender.value)

        fontSizeLabel.text = String(fontSize)
        delegate?.changeFontSize(to: fontSize)
    }
}
