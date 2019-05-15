//
//  TextContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/16.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit
import HueKit

protocol TextContainerDelegate: AnyObject {
    
    func alignmentChange(to type: NSTextAlignment)
    func textColorChange(to color: UIColor)
    func textTransparency(value: CGFloat)
    func changeFont(to fontName: FontName)
    func changeFont(to font: UIFont)
    func changeFont(to size: Int)
    func changeTextWith(lineHeight: Float, letterSpacing: Float)
    func changeLetterTo(upperCase: Bool)
    
}

class TextContainerViewController: UIViewController,
    UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: TextContainerDelegate?
   
    var currentFont: UIFont? {
        
        didSet {
            
            fontSizeButton.setTitle(String(describing: currentFont?.pointSize), for: .normal)
            fontTableView.reloadData()
        }
        
    }
    
    var currentFontName: FontName = FontName.helveticaNeue
    var textAlignment: NSTextAlignment?
    var tableViewIndex: TableViewCellType?
    var originalText = ""
    var upperCase: Bool = false
    
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
        
        didSet {
            
            fontSizeButton.setTitle(String(describing: currentFont?.pointSize), for: .normal)
            setupShadow(for: fontSizeButton)
            
        }
        
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
            textAlignment = .right
            
        case .right?:
            delegate?.alignmentChange(to: .left)
            alignmentButton.setImage(UIImage(named: ImageAsset.Icon_AlignLeft.rawValue), for: .normal)
            textAlignment = .left
            
        default:
            delegate?.alignmentChange(to: .center)
            alignmentButton.setImage(UIImage(named: ImageAsset.Icon_AlignCenter.rawValue), for: .normal)
            textAlignment = .center

        }
        
    }
    
    @IBAction func boldButtonTapped(_ sender: UIButton) {
        
        guard let size = currentFont?.pointSize else { return }
        
        var font: UIFont?
        
        switch boldButton.currentTitleColor {
        case UIColor.DSColor.yellow:
            
            boldButton.setTitleColor(UIColor.white, for: .normal)
            
            switch italicButton.currentTitleColor {
            case UIColor.DSColor.yellow:
                
                font = UIFont(name: currentFontName.italicStyle(), size: size)
                
            default:
                
                font = UIFont(name: currentFontName.rawValue, size: size) 
                
            }
            
        default:
            
            switch italicButton.currentTitleColor {
            case UIColor.DSColor.yellow:
                
                font = UIFont(name: currentFontName.boldItalicStyle(), size: size)
               
            default:
                
                font = UIFont(name: currentFontName.boldStyle(), size: size)
               
            }

            boldButton.setTitleColor(UIColor.DSColor.yellow, for: .normal)
        }
        
        if let font = font {
        
            delegate?.changeFont(to: font)

        }
        
    }
    
    @IBAction func italicButtonTapped(_ sender: Any) {
        
        guard let size = currentFont?.pointSize else { return }
        
        var font: UIFont? = UIFont()
        
        switch italicButton.currentTitleColor {
            
        case UIColor.DSColor.yellow:
            
            italicButton.setTitleColor(UIColor.white, for: .normal)
            
            switch boldButton.currentTitleColor {
                
            case UIColor.DSColor.yellow:
                
                font = UIFont(name: currentFontName.boldStyle(), size: size)
                
            default:
                
                font = UIFont(name: currentFontName.rawValue, size: size)
               
            }
            
        default:
            
            italicButton.setTitleColor(UIColor.DSColor.yellow, for: .normal)
            
            switch boldButton.currentTitleColor {
                
            case UIColor.DSColor.yellow:
                
                font = UIFont(name: currentFontName.boldItalicStyle(), size: size)
              
            default:
                
                font = UIFont(name: currentFontName.italicStyle(), size: size)
            }
            
        }
        
        if let font = font {
            
            delegate?.changeFont(to: font)
        }
        
    }
    
    @IBAction func letterCaseBtnTapped(_ sender: UIButton) {
        
        switch letterCaseButton.titleLabel?.text {
            
        case "Aa":
            
            letterCaseButton.setTitle("AA", for: .normal)

            delegate?.changeLetterTo(upperCase: true)
            
        default:
            
            letterCaseButton.setTitle("Aa", for: .normal)
            delegate?.changeLetterTo(upperCase: false)

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
            
            spacingCell.delegate = self
            
            return spacingCell
            
        default:
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: FontSizeTableViewCell.self),
                for: indexPath)
            
            guard let fontSizeCell = cell as? FontSizeTableViewCell else { return cell }
        
            guard let fontSize = currentFont?.pointSize else {return cell}
            
            fontSizeCell.delegate = self
            
//            fontSizeCell.setupCell(with: fontSize)
            
            fontSizeCell.slider.value = Float(fontSize)
            fontSizeCell.fontSizeLabel.text = "\(Int(fontSize))"
            
            return fontSizeCell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableViewIndex == .fontCell {
            
            let font = FontName.allCases[indexPath.row]
            
            currentFontName = font
            currentFontButton.setTitle(font.rawValue, for: .normal)
            currentFontButton.titleLabel?.font = UIFont(name: font.rawValue, size: 20)
            
            tableView.reloadData()
            
            delegate?.changeFont(to: font)
            
            //Setup Bold and Italic Buttons
            setupTool(with: FontName.allCases[indexPath.row])
        }
    }
    
    func setupShadow(for button: UIButton) {
        
        button.layer.cornerRadius = 8
        
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowColor = UIColor.DSColor.heavyGray.cgColor
        
    }
    
    func setupTool(with font: FontName) {
        
        let number = font.fontStyle()
        
        switch number {
        case 0:
            boldButton.disableMode()
            italicButton.disableMode()
        case 1:
            boldButton.enableMode()
            italicButton.disableMode()
        case 2:
            boldButton.disableMode()
            italicButton.enableMode()
        case 3, 4:
            boldButton.enableMode()
            italicButton.enableMode()
            
        default:
            break
        }
        
    }
    
}

extension TextContainerViewController: SpacingTableViewCellDelegate, FontSizeTableViewCellDelegate {
    
    func changeTextAttributeWith(lineHeight: Float, letterSpacing: Float) {
        
        delegate?.changeTextWith(lineHeight: lineHeight, letterSpacing: letterSpacing)
        
    }
    
    func changeFontSize(to size: Int) {
        
        guard let fontName = currentFont?.fontName else { return }
        currentFont = UIFont(name: fontName, size: CGFloat(size))
        
        delegate?.changeFont(to: size)
    }
    
    func textIs(upperCase: Bool) {
        
        if upperCase {
            letterCaseButton.setTitle("AA", for: .normal)
        } else {
            
            letterCaseButton.setTitle("Aa", for: .normal)
        }
    }
    
    func setupAllTool(alignment: NSTextAlignment, font: UIFont, upperCase: Bool, alpha: CGFloat, textColor: UIColor) {
        slider.value = Float(alpha*100)
        textAlignment = alignment
        currentFont = font
        textIs(upperCase: upperCase)
        colorButton.backgroundColor = textColor.withAlphaComponent(1)
        
    }
}
