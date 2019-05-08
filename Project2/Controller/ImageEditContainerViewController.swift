//
//  ImageEditContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/7.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit
import HueKit
import Photos

class ImageEditContainerViewController: BaseContainerViewController {

    @IBOutlet weak var transparencyUnderLine: UIView!

    deinit {
        print("ImageEditContainer is deinit")
    }
 
    @IBOutlet weak var transparencyBtn: UIButton! {
        
        didSet {
            
            transparencyBtn.setImage(ImageAsset.Icon_transparency.imageTemplate, for: .normal)
            transparencyBtn.tintColor = UIColor.DSColor.lightGreen
            
        }
        
    }
    
    @IBOutlet weak var paletteView: UIView!
    @IBOutlet weak var defaultColorView: UIView!
    @IBOutlet weak var transparencyView: UIView!
    
    @IBOutlet weak var usedColorButton: UIButton!
    @IBOutlet weak var slider: UISlider! 

    @IBOutlet weak var transparencyLabel: UILabel!
    
    @IBOutlet weak var whiteColorButton: UIButton! {
        
        didSet {
            
            whiteColorButton.layer.borderWidth = 1
            whiteColorButton.layer.borderColor = UIColor.DSColor.lightGray.cgColor
            
        }
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

        filterCollectionView.al_registerCellWithNib(identifier: String(describing: FilterCollectionViewCell.self),
                                                    bundle: nil)
        
        createNotification()

    }
    
    @IBAction func cameraRollBtnTapped(_ sender: Any) {
        
        cameraRollButton.tintColor = UIColor.DSColor.heavyGreen
        colorButton.tintColor = UIColor.DSColor.lightGreen
        transparencyBtn.tintColor = UIColor.DSColor.lightGreen
        filterView.tintColor = UIColor.DSColor.lightGreen
        
        photoView.isHidden = false
        transparencyView.isHidden = true
        filterView.isHidden = true
        defaultColorView.isHidden = true
        paletteView.isHidden = true

        cameraUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        transparencyUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        filterUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
    }
    
    @IBAction func colorsBtnTapped(_ sender: Any) {
        
        cameraRollButton.tintColor = UIColor.DSColor.lightGreen
        colorButton.tintColor = UIColor.DSColor.heavyGreen
        transparencyBtn.tintColor = UIColor.DSColor.lightGreen
        filterButton.tintColor = UIColor.DSColor.lightGreen
        
        cameraUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        transparencyUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        filterUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
        transparencyView.isHidden = true
        photoView.isHidden = true
        filterView.isHidden = true
        defaultColorView.isHidden = false
        
    }
    
    @IBAction func filterBtnTapped(_ sender: Any) {
        
        filterView.isHidden = false
        
        cameraRollButton.tintColor = UIColor.DSColor.lightGreen
        colorButton.tintColor = UIColor.DSColor.lightGreen
        transparencyBtn.tintColor = UIColor.DSColor.lightGreen
        filterButton.tintColor = UIColor.DSColor.heavyGreen
        
        cameraUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        transparencyUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        filterUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        
        transparencyView.isHidden = true
        photoView.isHidden = true
        filterView.isHidden = false
        defaultColorView.isHidden = true
        paletteView.isHidden = true
        
    }

    @IBAction func transparencyBtnTapped(_ sender: Any) {

        cameraRollButton.tintColor = UIColor.DSColor.lightGreen
        colorButton.tintColor = UIColor.DSColor.lightGreen
        transparencyBtn.tintColor = UIColor.DSColor.heavyGreen
        
        cameraUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        transparencyUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        filterUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
        transparencyView.isHidden = false
        photoView.isHidden = true
        filterView.isHidden = true
        defaultColorView.isHidden = true
        paletteView.isHidden = true
    }
    
    @IBAction func photoLibraryBtnTapped(_ sender: UIButton) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
            
        case PHAuthorizationStatus.authorized:
            
            let notificationName = Notification.Name(NotiName.changeImageWithAlbum.rawValue)
            NotificationCenter.default.post(
                name: notificationName,
                object: nil,
                userInfo: [NotificationInfo.changeImageWithAlbum: true])
            
        case PHAuthorizationStatus.notDetermined:
            
            PHPhotoLibrary.requestAuthorization({ status in
                
                if status == .authorized {
                    
                    let notificationName = Notification.Name(NotiName.changeImageWithAlbum.rawValue)
                    NotificationCenter.default.post(
                        name: notificationName,
                        object: nil,
                        userInfo: [NotificationInfo.changeImageWithAlbum: true])
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
            
            let notificationName = Notification.Name(NotiName.changeImageByCamera.rawValue)
            NotificationCenter.default.post(
                name: notificationName,
                object: nil,
                userInfo: [NotificationInfo.changeImageWithAlbum: true])
            
        case AVAuthorizationStatus.notDetermined:
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                
                if granted {
                    
                    let notificationName = Notification.Name(NotiName.changeImageByCamera.rawValue)
                    NotificationCenter.default.post(
                        name: notificationName,
                        object: nil,
                        userInfo: [NotificationInfo.changeImageWithAlbum: true])
                    
                }
                
            }
            
        default:
            delegate?.showCameraAlert()
        }
        
    }
    
    @IBAction func usedColorBtnTapped(_ sender: Any) {
        
        paletteView.isHidden = false
        defaultColorView.isHidden = true
        
        let notificationName = Notification.Name(NotiName.addElementButton.rawValue)
        
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.addElementButton: false])
        
    }
    
    @IBAction func defaultColorBtnTapped(_ sender: UIButton) {
        
        guard let color = sender.backgroundColor else { return }
        
        let notificationName = Notification.Name(NotiName.changeEditingViewColor.rawValue)
        
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.changeEditingViewColor: color])
   
    }
    
    @IBAction func colorBarPickerValueChanged(_ sender: ColorBarPicker) {
        
        colorSquarePicker.hue = sender.hue
        
        let notificationName = Notification.Name(NotiName.changeEditingViewColor.rawValue)
        
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.changeEditingViewColor: colorSquarePicker.color])
       
    }
    
    @IBAction func colorSquarePickerValueChanged(_ sender: ColorSquarePicker) {
       
        let notificationName = Notification.Name(NotiName.changeEditingViewColor.rawValue)
        
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.changeEditingViewColor: sender.color])
        
    }
    
    @IBAction func checkBtnTapped(_ sender: Any) {
        
        paletteView.isHidden = true
        
        let notificationName = Notification.Name(NotiName.addElementButton.rawValue)
        
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.addElementButton: true])
    }
    
    @IBAction func sliderDidSlide(_ sender: UISlider) {
        
        transparencyLabel.text = "\(Int(sender.value))"
        
    }
    
    override func editImageMode() {
        
        super.editImageMode()
        
        filterView.isHidden = false
        
        photoView.isHidden = true
        transparencyView.isHidden = true
        defaultColorView.isHidden = true
        paletteView.isHidden = true
        
        cameraRollButton.isHidden = false
        cameraUnderLine.isHidden = false
        filterButton.isHidden = false
        filterUnderLine.isHidden = false
        
        cameraRollButton.tintColor = UIColor.DSColor.lightGreen
        cameraUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        colorButton.tintColor = UIColor.DSColor.lightGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        transparencyBtn.tintColor = UIColor.DSColor.lightGreen
        transparencyUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
        filterButton.tintColor = UIColor.DSColor.heavyGreen
        filterUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        
    }
    
    override func editShapeMode() {
        
        photoView.isHidden = true
        filterView.isHidden = true
        transparencyView.isHidden = true
        defaultColorView.isHidden = false
        paletteView.isHidden = true
        
        cameraRollButton.isHidden = true
        cameraUnderLine.isHidden = true
        filterButton.isHidden = true
        filterUnderLine.isHidden = true
        
        colorButton.tintColor = UIColor.DSColor.heavyGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        
        transparencyBtn.tintColor = UIColor.DSColor.lightGreen
        transparencyUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
    }
   
}

extension ImageEditContainerViewController {
    
    //Notification for image picked
    func createNotification() {
        
        // 註冊addObserver
        let notificationName = Notification.Name(NotiName.didChangeImage.rawValue)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeImage(noti:)), name: notificationName, object: nil)

    }
    
    // 收到通知後要執行的動作
    @objc func changeImage(noti: Notification) {
        if let userInfo = noti.userInfo,
            let mode = userInfo[NotificationInfo.didChangeImage] as? Bool {
            
            if mode == true {

                cameraRollButton.tintColor = UIColor.DSColor.lightGreen
                
            }
        }
    }
}
