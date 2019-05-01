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
    
}

class ContainerViewController: UIViewController, PhotoManagerDelegate {

    @IBOutlet weak var colorSquarePicker: ColorSquarePicker!
    @IBOutlet weak var colorIndicatorView: ColorIndicatorView!
    
    @IBOutlet weak var photoView: UIView!
    
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
    
    @IBOutlet weak var filterButton: UIButton!
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

    @IBOutlet weak var collectionView: UICollectionView! {

        didSet {

            collectionView.delegate = self

            collectionView.dataSource = self

        }
    }
    
    weak var delegate: ContainerViewControllerProtocol?

    let photoManager = PhotoManager()
    var imageArray: [UIImage] = []

    var imageURL: [URL] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorButton.isSelected = true

        createNotification()
        
//        didChangeColor(colorSquarePicker.color)

//        collectionView.al_registerCellWithNib(identifier: String(describing:
//        PhotoCollectionViewCell.self), bundle: nil)
//        collectionView.al_registerHeaderViewWithNib(identifier:  String(describing:
//        CollectionReusableView.self), bundle: nil)

//        setupCollectionViewLayout()

//        photoManager.delegate = self
//        photoManager.grabPhoto()

    }

    @IBAction func cameraRollBtnTapped(_ sender: Any) {
        
        photoView.isHidden = false
        
        colorButton.tintColor = UIColor.DSColor.lightGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
        cameraRollButton.tintColor = UIColor.DSColor.heavyGreen
        cameraUnderLine.backgroundColor = UIColor.DSColor.heavyGreen

    }

    @IBAction func filterBtnTapped(_ sender: Any) {

//        filterButton.isSelected = true
        colorButton.isSelected = false
    }

    @IBAction func colorBtnTapped(_ sender: Any) {

//        filterButton.isSelected = false
        
        photoView.isHidden = true
        
        colorButton.tintColor = UIColor.DSColor.heavyGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        
        cameraRollButton.tintColor = UIColor.DSColor.lightGreen
        cameraUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
    }
    func setupImage() {
        collectionView.reloadData()
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
}

extension ContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return imageArray.count

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: PhotoCollectionViewCell.self),
            for: indexPath)
        
        guard let photoCell = cell as? PhotoCollectionViewCell else {
            return cell
        }

        photoCell.photoImage.image = imageArray[indexPath.item]

        return photoCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let notificationName = Notification.Name(NotiName.changeBackground.rawValue)
//        NotificationCenter.default.post(name: notificationName, object: nil, userInfo:
//        [NotificationInfo.newImage: imageArray[indexPath.item]])

        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.newImage: imageURL[indexPath.item]])

    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath)
    -> UICollectionReusableView {

        let reusableView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: String(describing: CollectionReusableView.self),
            for: indexPath)

        guard let header = reusableView as? CollectionReusableView else { return reusableView }

        return header

    }
}

extension ContainerViewController {

    private func setupCollectionViewLayout() {

        let flowLayout = UICollectionViewFlowLayout()

        flowLayout.itemSize = CGSize(
            width: UIScreen.main.bounds.width/4,
            height: UIScreen.main.bounds.width/4
        )

        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        flowLayout.minimumInteritemSpacing = 0

        flowLayout.minimumLineSpacing = 0

        flowLayout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 40) // header zone

        collectionView.collectionViewLayout = flowLayout
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
