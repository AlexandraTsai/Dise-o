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
    
    func hideColorPicker()
    
}

class TextContainerViewController: UIViewController {
    
    weak var delegate: TextContainerProtocol!

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
    }
    
    @IBAction func sliderDidSlide(_ sender: UISlider) {
        
        let transparency = CGFloat(sender.value/100)
        
        let notificationName = Notification.Name(NotiName.textTransparency.rawValue)
        
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.textTransparency: transparency])
        
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        if colorPickerView.isHidden {
        
            delegate.hideColorPicker()
            
        } else {
            
            colorPickerView.isHidden = true
            
        }
       
    }
    
    @IBAction func usedColorBtnTapped(_ sender: Any) {
        
        colorPickerView.isHidden = false
    }
    
    @IBAction func defaultColorBtnTapped(_ sender: UIButton) {
        
        let notificationName = Notification.Name(NotiName.textColor.rawValue)
        
        guard let color = sender.backgroundColor else { return }
        
        NotificationCenter.default.post(name: notificationName,
                                        object: nil,
                                        userInfo: [NotificationInfo.textColor: color])
        
    }

    @IBAction func colorSquarePickerValueChanged(_ sender: ColorSquarePicker) {
        
        let notificationName = Notification.Name(NotiName.textColor.rawValue)
        
        NotificationCenter.default.post(name: notificationName,
                                        object: nil,
                                        userInfo: [NotificationInfo.textColor: colorSquarePicker.color])
        
    }
    
    @IBAction func colorBarPickerValueChanged(_ sender: ColorBarPicker) {
        
        colorSquarePicker.hue = sender.hue
        
        let notificationName = Notification.Name(NotiName.textColor.rawValue)
        
        NotificationCenter.default.post(name: notificationName,
                                        object: nil,
                                        userInfo: [NotificationInfo.textColor: colorSquarePicker.color])
      
    }
}
