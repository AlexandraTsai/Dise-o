//
//  TextContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/16.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit
import HueKit

protocol TextContainerProtocol: AnyObject {
    
//    func hideColorPicker()
    func alignmentChange(to type: NSTextAlignment)
    func beBold()
    func textColorChange(to color: UIColor)
    func textTransparency(value: CGFloat)
    
}

class TextContainerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: TextContainerProtocol?
   
    var currentFontName: FontName = FontName.helveticaNeue

    var textAlignment: NSTextAlignment?
    var tableViewIndex: TableViewCellType?
    var originalText = ""
    
    @IBOutlet weak var textToolView: UIView!
    @IBOutlet weak var colorToolView: UIView!
    @IBOutlet weak var fontToolView: UIView!
    
    //Text Tool
    @IBOutlet weak var currentFontButton: UIButton! {
        
        didSet {
            
            currentFontButton.titleLabel?.adjustsFontSizeToFitWidth = true
            
        }
    }
    
    @IBOutlet weak var alignmentButton: UIButton!
    @IBOutlet weak var letterCaseButton: UIButton!
    @IBOutlet weak var italicButton: UIButton!
    @IBOutlet weak var boldButton: UIButton!
    @IBOutlet weak var fontSizeButton: UIButton! {
        
        didSet { setupShadow(for: fontSizeButton) }
        
    }
    
    @IBOutlet weak var colorButton: UIButton! {
        
        didSet { setupShadow(for: colorButton) }
        
    }
    
    @IBOutlet weak var toolView: UIView! {
        
        didSet {
            
            toolView.layer.cornerRadius = 6
            toolView.layer.shadowColor = UIColor.DSColor.heavyGray.cgColor
            toolView.layer.shadowOffset = CGSize(width: 0, height: 0)
            toolView.layer.shadowRadius = 6
            toolView.layer.shadowOpacity = 1
            
        }
    }
    
    //Font Tool
    @IBOutlet weak var fontTableView: UITableView! {
        
        didSet {
            
            fontTableView.delegate = self
            fontTableView.dataSource = self
        }
    }
    
    //Color Tool
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var colorPickerView: UIView!
    @IBOutlet weak var colorSquarePicker: ColorSquarePicker!
    @IBOutlet weak var colorBarPicker: ColorBarPicker!
    
    @IBOutlet weak var usedColorButton: UIButton!
    
    @IBOutlet weak var whiteColorButton: UIButton! {
        
        didSet {
            
            whiteColorButton.layer.borderColor = UIColor.DSColor.lightGray.cgColor
            whiteColorButton.layer.borderWidth = 1
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colorPickerView.isHidden = true
        
        fontTableView.al_registerCellWithNib(identifier: String(describing: FontTableViewCell.self), bundle: nil)
        fontTableView.al_registerCellWithNib(identifier: String(describing: SpacingTableViewCell.self), bundle: nil)
        fontTableView.al_registerCellWithNib(identifier: String(describing: FontSizeTableViewCell.self), bundle: nil)

    }
    
    @IBAction func fontButtonTapped(_ sender: UIButton) {
        
        tableViewIndex = .fontCell
        textToolView.isHidden = true

        fontTableView.isScrollEnabled = true
        fontTableView.reloadData()
//        selectFontView.isHidden = false

    }
    
    @IBAction func colorButtonTapped(_ sender: UIButton) {
        
        textToolView.isHidden = true
        fontToolView.isHidden = true
    }
    
    @IBAction func fontSizeButtonTapped(_ sender: UIButton) {
    
        textToolView.isHidden = true

        tableViewIndex = .fontSizeCell
        fontTableView.reloadData()
        fontTableView.isScrollEnabled = false
        
    }
    
    @IBAction func alignmentButtonTapped(_ sender: UIButton) {
        
        switch textAlignment {
        case .center?:
            delegate?.alignmentChange(to: .right)
            alignmentButton.setImage(UIImage(named: ImageAsset.Icon_AlignRight.rawValue), for: .normal)
            
        case .right?:
            delegate?.alignmentChange(to: .left)
            alignmentButton.setImage(UIImage(named: ImageAsset.Icon_AlignLeft.rawValue), for: .normal)
            
        default:
            delegate?.alignmentChange(to: .center)
            alignmentButton.setImage(UIImage(named: ImageAsset.Icon_AlignCenter.rawValue), for: .normal)
        }
        
    }
    
    @IBAction func spacingButtonTapped(_ sender: UIButton) {
        
        tableViewIndex = .spacingCell
        
        fontTableView.isScrollEnabled = false
        fontTableView.reloadData()
        fontTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        
        textToolView.isHidden = true
        fontToolView.isHidden = false
        
    }
    
    @IBAction func endupEdit(_ sender: UIButton) {
        
        textToolView.isHidden = false
    }
   
    @IBAction func sliderDidSlide(_ sender: UISlider) {
        
        let transparency = CGFloat(sender.value/100)
        
        delegate?.textTransparency(value: transparency)
        
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        if colorPickerView.isHidden {
        
            textToolView.isHidden = false
            fontToolView.isHidden = false
            
        } else {
            
            colorPickerView.isHidden = true
            
        }
       
    }
    
    @IBAction func usedColorBtnTapped(_ sender: Any) {
        
        colorPickerView.isHidden = false
    }
    
    @IBAction func defaultColorBtnTapped(_ sender: UIButton) {
        
        guard let color = sender.backgroundColor else { return }

        delegate?.textColorChange(to: color)
        colorButton.backgroundColor = color
        
    }

    @IBAction func colorSquarePickerValueChanged(_ sender: ColorSquarePicker) {
        
        delegate?.textColorChange(to: colorSquarePicker.color)
        colorButton.backgroundColor = colorSquarePicker.color
    }
    
    @IBAction func colorBarPickerValueChanged(_ sender: ColorBarPicker) {
        
        colorSquarePicker.hue = sender.hue
        
        delegate?.textColorChange(to: colorSquarePicker.color)
        colorButton.backgroundColor = colorSquarePicker.color
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableViewIndex {
        case .fontCell?:
            
            return FontName.allCases.count
       
        default:
            
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableViewIndex {
        case .fontCell?:
           
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: FontTableViewCell.self),
                for: indexPath)
            
            guard let fontCell = cell as? FontTableViewCell else { return cell }
            
            fontCell.fontLabel.text = FontName.allCases[indexPath.row].rawValue
            fontCell.fontLabel.font = UIFont(name: FontName.allCases[indexPath.row].rawValue, size: 18)
            
            if currentFontName == FontName.allCases[indexPath.row] {
                
                fontCell.fontLabel.textColor = UIColor.DSColor.yellow
                
            } else {
                
                fontCell.fontLabel.textColor = UIColor.black
                
            }
            
            return fontCell
        case .spacingCell?:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SpacingTableViewCell.self),
                for: indexPath)
            
            guard let spacingCell = cell as? SpacingTableViewCell else { return cell }
            
//            spacingCell.delegate = self
            
            return spacingCell
            
        default:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: FontSizeTableViewCell.self),
                for: indexPath)
            
            guard let fontSizeCell = cell as? FontSizeTableViewCell else { return cell }
            
//            guard let view = editingView as? ALTextView else { return cell }
//            guard let fontSize = view.font?.pointSize else {return cell}
            
//            fontSizeCell.delegate = self
            
//            fontSizeCell.fontSizeLabel.text = "\(Int(fontSize))"
            return fontSizeCell
            
        }
    }
    
    func setupShadow(for button: UIButton) {
        
        button.layer.cornerRadius = 8
        
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowColor = UIColor.DSColor.heavyGray.cgColor
        
    }
    
}
