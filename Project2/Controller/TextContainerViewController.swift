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
    
    @IBOutlet weak var textToolView: UIView! {
            
        didSet {
                
            textToolView.layer.cornerRadius = 6
            textToolView.layer.shadowColor = UIColor.DSColor.heavyGray.cgColor
            textToolView.layer.shadowOffset = CGSize(width: 0, height: 0)
            textToolView.layer.shadowRadius = 6
            textToolView.layer.shadowOpacity = 1
                
        }
    }
    
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
        
        fontTableView.isScrollEnabled = true
        fontTableView.reloadData()
//        selectFontView.isHidden = false

    }
    
    @IBAction func colorButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func fontSizeButtonTapped(_ sender: UIButton) {
    
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
    
    @IBAction func endupEdit(_ sender: UIButton) {
        
    }
   
    //
    @IBAction func sliderDidSlide(_ sender: UISlider) {
        
        let transparency = CGFloat(sender.value/100)
        
//        let notificationName = Notification.Name(NotiName.textTransparency.rawValue)
//
//        NotificationCenter.default.post(
//            name: notificationName,
//            object: nil,
//            userInfo: [NotificationInfo.textTransparency: transparency])
        
        delegate?.textTransparency(value: transparency)
        
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        if colorPickerView.isHidden {
        
            textToolView.isHidden = false
            
        } else {
            
            colorPickerView.isHidden = true
            
        }
       
    }
    
    @IBAction func usedColorBtnTapped(_ sender: Any) {
        
        colorPickerView.isHidden = false
    }
    
    @IBAction func defaultColorBtnTapped(_ sender: UIButton) {
        
//        let notificationName = Notification.Name(NotiName.textColor.rawValue)
//
        guard let color = sender.backgroundColor else { return }
//
//        NotificationCenter.default.post(name: notificationName,
//                                        object: nil,
//                                        userInfo: [NotificationInfo.textColor: color])

        delegate?.textColorChange(to: color)
        colorButton.backgroundColor = color
        
    }

    @IBAction func colorSquarePickerValueChanged(_ sender: ColorSquarePicker) {
        
//        let notificationName = Notification.Name(NotiName.textColor.rawValue)
//
//        NotificationCenter.default.post(name: notificationName,
//                                        object: nil,
//                                        userInfo: [NotificationInfo.textColor: colorSquarePicker.color])
//
        
        delegate?.textColorChange(to: colorSquarePicker.color)
        colorButton.backgroundColor = colorSquarePicker.color
    }
    
    @IBAction func colorBarPickerValueChanged(_ sender: ColorBarPicker) {
        
        colorSquarePicker.hue = sender.hue
        
        let notificationName = Notification.Name(NotiName.textColor.rawValue)
        
        NotificationCenter.default.post(name: notificationName,
                                        object: nil,
                                        userInfo: [NotificationInfo.textColor: colorSquarePicker.color])
      
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
