//
//  ContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/1.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit
import Photos
import HueKit

class BackgroundContainerViewController: BaseContainerViewController {
    
    @IBOutlet weak var colorIndicatorView: ColorIndicatorView!

    @IBAction func cameraRollBtnTapped(_ sender: Any) {
        
        photoView.isHidden = false
        filterView.isHidden = true
        
        colorButton.tintColor = UIColor.DSColor.lightGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
        cameraRollButton.tintColor = UIColor.DSColor.heavyGreen
        cameraUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        
        filterButton.tintColor = UIColor.DSColor.lightGreen
        filterUnderLine.backgroundColor = UIColor.DSColor.lightGreen

    }

    @IBAction func filterBtnTapped(_ sender: Any) {

        photoView.isHidden = true
        filterView.isHidden = false
        
        filterButton.tintColor = UIColor.DSColor.heavyGreen
        filterUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        
        cameraRollButton.tintColor = UIColor.DSColor.lightGreen
        cameraUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
        colorButton.tintColor = UIColor.DSColor.lightGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen
    
    }

    @IBAction func colorBtnTapped(_ sender: Any) {

        filterView.isHidden = true
        photoView.isHidden = true
        
        colorButton.tintColor = UIColor.DSColor.heavyGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        
        cameraRollButton.tintColor = UIColor.DSColor.lightGreen
        cameraUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
        filterButton.tintColor = UIColor.DSColor.lightGreen
        filterUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
    }
    
    @IBAction func colorBarPickerValueChnaged(_ sender: ColorBarPicker) {
       
        colorSquarePicker.hue = sender.hue
        
        delegate?.changeColor(to: colorSquarePicker.color)
      
        let notificationName = Notification.Name(NotiName.backgroundColor.rawValue)
        
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.backgroundColor: colorSquarePicker.color])
        
    }
    
    @IBAction func colorSquarePickerValueChanged(_ sender: ColorSquarePicker) {
    
        delegate?.changeColor(to: sender.color)

    }
    
    @IBAction func photoLibraryBtnTapped(_ sender: UIButton) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        
        case PHAuthorizationStatus.authorized:
            
            delegate?.pickImageWithAlbum()
            
        case PHAuthorizationStatus.notDetermined:
            
            PHPhotoLibrary.requestAuthorization({[weak self] status in
                
                if status == .authorized {
                    
                    self?.delegate?.pickImageWithAlbum()
                    
                }
                
            })
            
        default:
            
            delegate?.showPhotoLibrayAlert()
        }
      
    }
    
    @IBAction func cameraBtnTapped(_ sender: UIButton) {
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch status {
        case AVAuthorizationStatus.authorized:
            
            delegate?.pickImageWithCamera()
  
        case AVAuthorizationStatus.notDetermined:

            AVCaptureDevice.requestAccess(for: AVMediaType.video) {[weak self] granted in
                if granted {
                    
                    self?.delegate?.pickImageWithCamera()
                    
                }
            }
            
        default:
            
            delegate?.showCameraAlert()
            
        }
    }
    
    override func editImageMode() {
        
        super.editImageMode()

        filterView.isHidden = false
        filterCollectionView.isHidden = false
        
        filterButton.tintColor = UIColor.DSColor.heavyGreen
        filterUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        
        cameraRollButton.tintColor = UIColor.DSColor.lightGreen
        cameraUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
        colorButton.tintColor = UIColor.DSColor.lightGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
    }
    
    override func noImageMode() {
        
        filterView.isHidden = true
        filterCollectionView.isHidden = true
        
        photoView.isHidden = true
        
        filterButton.tintColor = UIColor.DSColor.lightGreen
        filterUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
        cameraRollButton.tintColor = UIColor.DSColor.lightGreen
        cameraUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
        colorButton.tintColor = UIColor.DSColor.heavyGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        
    }
    
    override func pickImageMode() {
        
        filterView.isHidden = true
        photoView.isHidden = false
        
        filterButton.tintColor = UIColor.DSColor.lightGreen
        filterUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
        cameraRollButton.tintColor = UIColor.DSColor.heavyGreen
        cameraUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        
        colorButton.tintColor = UIColor.DSColor.lightGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
    }

}
