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

protocol ContainerViewControllerProtocol: AnyObject {
    
    func showPhotoLibrayAlert()
    func showCameraAlert()
    func changeImageWith(filter: FilterType?)
    
}

class ContainerViewController: BaseContainerViewController {

    @IBOutlet weak var colorSquarePicker: ColorSquarePicker!
    @IBOutlet weak var colorIndicatorView: ColorIndicatorView!
    
    @IBOutlet weak var photoView: UIView!

    deinit {
        print("ContainerVC is deinit")
    }
    
    @IBOutlet weak var cameraRollButton: UIButton! {
        
        didSet {
            
            cameraRollButton.setImage(ImageAsset.Icon_image.imageTemplate, for: .normal)
            
            cameraRollButton.tintColor = UIColor.DSColor.heavyGreen
            
        }
    }
    
    @IBOutlet weak var cameraUnderLine: UIView! {
        
        didSet {
            
            cameraUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
            
        }
        
    }
    
    @IBOutlet weak var filterButton: UIButton! {
        
        didSet {
            
            filterButton.setImage(ImageAsset.Icon_filter.imageTemplate, for: .normal)
            
            filterButton.tintColor = UIColor.DSColor.heavyGreen
            
        }
        
    }
    
    @IBOutlet weak var filterUnderLine: UIView! {
        
        didSet {
            
            filterUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        }

    }
    
    @IBOutlet weak var colorButton: UIButton! {
        
        didSet {
            
            colorButton.setImage(ImageAsset.Icon_color.imageTemplate, for: .normal)
            
            colorButton.tintColor = UIColor.DSColor.lightGreen
            
        }
    }
    
    @IBOutlet weak var colorUnderLine: UIView! {
        
        didSet {
            
            colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen
            
        }
        
    }

    weak var delegate: ContainerViewControllerProtocol?

    let photoManager = PhotoManager()
    var imageArray: [UIImage] = []

    var imageURL: [URL] = []

    override func viewDidLoad() {
        super.viewDidLoad()
      
        createNotification()

        setupCollectionViewLayout()
    }

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
      
        let notificationName = Notification.Name(NotiName.backgroundColor.rawValue)
        
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.backgroundColor: colorSquarePicker.color])
        
    }
    
    @IBAction func colorSquarePickerValueChanged(_ sender: ColorSquarePicker) {
        
        let notificationName = Notification.Name(NotiName.backgroundColor.rawValue)
        
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.backgroundColor: sender.color])
    }
    
    @IBAction func photoLibraryBtnTapped(_ sender: UIButton) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        
        case PHAuthorizationStatus.authorized:
            
            let notificationName = Notification.Name(NotiName.pickingPhotoMode.rawValue)
            
            NotificationCenter.default.post(
                name: notificationName,
                object: nil,
                userInfo: [NotificationInfo.pickingPhotoMode: true])
            
        case PHAuthorizationStatus.notDetermined:
            
            PHPhotoLibrary.requestAuthorization({ status in
                
                if status == .authorized {
                    
                    let notificationName = Notification.Name(NotiName.pickingPhotoMode.rawValue)
                    
                    NotificationCenter.default.post(
                        name: notificationName,
                        object: nil,
                        userInfo: [NotificationInfo.pickingPhotoMode: true])
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
            
            let notificationName = Notification.Name(NotiName.takePhotoMode.rawValue)
            
            NotificationCenter.default.post(
                name: notificationName,
                object: nil,
                userInfo: [NotificationInfo.takePhotoMode: true])
           
        case AVAuthorizationStatus.notDetermined:

            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                if granted {
                    
                    let notificationName = Notification.Name(NotiName.takePhotoMode.rawValue)
                    
                    NotificationCenter.default.post(
                        name: notificationName,
                        object: nil,
                        userInfo: [NotificationInfo.takePhotoMode: true])
                    
                }
            }
            
        default:
            
            delegate?.showCameraAlert()
            
        }
    }
    
    override func editImageMode() {
        
        filterView.isHidden = false
        filterCollectionView.isHidden = false
        
        filterButton.tintColor = UIColor.DSColor.heavyGreen
        filterUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        
        cameraRollButton.tintColor = UIColor.DSColor.lightGreen
        cameraUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
        colorButton.tintColor = UIColor.DSColor.lightGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
    }
}

extension ContainerViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.item == 0 {
            
            delegate?.changeImageWith(filter: nil)
            
        } else {
            
            delegate?.changeImageWith(filter: FilterType.allCases[indexPath.item-1])
            
        }
        
    }
   
    func noImageMode() {
        
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
    func pickImageMode() {
        
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

extension ContainerViewController {

    private func setupCollectionViewLayout() {

        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(
            width: UIScreen.main.bounds.width/5,
            height: UIScreen.main.bounds.width/5
        )
        
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        flowLayout.minimumInteritemSpacing = 5
        
        flowLayout.minimumLineSpacing = 0
        
        filterCollectionView.collectionViewLayout = flowLayout
    }
}

extension ContainerViewController {

    func createNotification() {

        // 註冊addObserver
        let notificationName = Notification.Name(NotiName.changeBackground.rawValue)

        NotificationCenter.default.addObserver(self, selector:
            #selector(changeBackground(noti:)), name: notificationName, object: nil)
    }

    @objc func changeBackground(noti: Notification) {

        if let userInfo = noti.userInfo,
            let mode = userInfo[NotificationInfo.backgroundIsImage] as? Bool {
            if mode == true {
//                filterButton.isHidden = false
//                filterButton.isSelected = true
                colorButton.isSelected = false
            } else {
//                filterButton.isHidden = true
                colorButton.isSelected = true
            }
        }
    }
}
