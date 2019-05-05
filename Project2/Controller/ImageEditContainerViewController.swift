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

protocol ImageEditContainerViewControllerProtocol: AnyObject {
    
    func showPhotoLibrayAlert()
    func showCameraAlert()
    func changeImageWith(filter: FilterType?)
    
}

class ImageEditContainerViewController: UIViewController, PhotoManagerDelegate {
    
    var imageToBeEdit: UIImage?
    
    weak var delegate: ImageEditContainerViewControllerProtocol?
    
    @IBOutlet weak var cameraUnderLine: UIView!
    @IBOutlet weak var colorUnderLine: UIView!
    @IBOutlet weak var transparencyUnderLine: UIView!
    @IBOutlet weak var filterUnderLine: UIView!
    
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var filterView: UIScrollView!
    @IBOutlet weak var filterCollectionView: UICollectionView! {
        
        didSet {
            filterCollectionView.delegate = self
            filterCollectionView.dataSource = self
        }
    }
    
    deinit {
        print("ImageEditContainer is deinit")
    }
    
    @IBOutlet weak var cameraRollBtn: UIButton! {
        
        didSet {
            
            cameraRollBtn.setImage(ImageAsset.Icon_image.imageTemplate, for: .normal)
            
        }
        
    }
    
    @IBOutlet weak var colorBtn: UIButton! {
        
        didSet {
            
            colorBtn.setImage(ImageAsset.Icon_color.imageTemplate, for: .normal)
            colorBtn.tintColor = UIColor.DSColor.heavyGreen
            
        }
        
    }
    
    @IBOutlet weak var filterBtn: UIButton! {
        
        didSet {
            
            filterBtn.setImage(ImageAsset.Icon_filter.imageTemplate, for: .normal)
            filterBtn.tintColor = UIColor.DSColor.lightGreen
            
        }
        
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
    
    @IBOutlet weak var colorSquarePicker: ColorSquarePicker!
    @IBOutlet weak var colorBarPicker: ColorBarPicker!
    @IBOutlet weak var usedColorButton: UIButton!
    @IBOutlet weak var slider: UISlider! 

    @IBOutlet weak var transparencyLabel: UILabel!
    
    @IBOutlet weak var whiteColorButton: UIButton! {
        
        didSet {
            
            whiteColorButton.layer.borderWidth = 1
            whiteColorButton.layer.borderColor = UIColor.DSColor.lightGray.cgColor
            
        }
        
    }
    
    @IBOutlet weak var imageCollectionView: UICollectionView! {

        didSet {
            imageCollectionView.delegate = self
            imageCollectionView.dataSource = self
        }
    }

    let photoManager = PhotoManager()
    var imageArray = [UIImage]()
    var imageURL = [URL]()
   
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
//        paletteView.isHidden = true
//        transparencyView.isHidden = true
//        filterView.isHidden = true
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

        filterCollectionView.al_registerCellWithNib(identifier: String(describing: FilterCollectionViewCell.self),
                                                    bundle: nil)

        setupCollectionViewLayout()
        
        createNotification()

    }
    
    func setupImage() {
        imageCollectionView.reloadData()
    }
    
    @IBAction func cameraRollBtnTapped(_ sender: Any) {
        
        cameraRollBtn.tintColor = UIColor.DSColor.heavyGreen
        colorBtn.tintColor = UIColor.DSColor.lightGreen
        transparencyBtn.tintColor = UIColor.DSColor.lightGreen
        filterBtn.tintColor = UIColor.DSColor.lightGreen
        
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
        
        cameraRollBtn.tintColor = UIColor.DSColor.lightGreen
        colorBtn.tintColor = UIColor.DSColor.heavyGreen
        transparencyBtn.tintColor = UIColor.DSColor.lightGreen
        filterBtn.tintColor = UIColor.DSColor.lightGreen
        
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
        
        cameraRollBtn.tintColor = UIColor.DSColor.lightGreen
        colorBtn.tintColor = UIColor.DSColor.lightGreen
        transparencyBtn.tintColor = UIColor.DSColor.lightGreen
        filterBtn.tintColor = UIColor.DSColor.heavyGreen
        
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

        cameraRollBtn.tintColor = UIColor.DSColor.lightGreen
        colorBtn.tintColor = UIColor.DSColor.lightGreen
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
   
}

extension ImageEditContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FilterType.allCases.count+1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: FilterCollectionViewCell.self),
            for: indexPath)
        
        guard let filterCell = cell as? FilterCollectionViewCell,
            let image = imageToBeEdit else { return cell }
        
        if indexPath.item == 0 {
         
            filterCell.filteredImage.image = image
            
        } else {
            
            filterCell.filteredImage.image = image.addFilter(filter: FilterType.allCases[indexPath.item-1])
        }

        return filterCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            
            delegate?.changeImageWith(filter: nil)
            
        } else {
            
            delegate?.changeImageWith(filter: FilterType.allCases[indexPath.item-1])
            
        }
        
    }

}

extension ImageEditContainerViewController {

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

extension ImageEditContainerViewController: BaseViewControllerDelegate {
   
    func showAllFilter(for image: UIImage) {
        
        imageToBeEdit = image
        
        filterCollectionView.reloadData()
    }
    
    func editImageMode() {
        
        filterView.isHidden = false
       
        photoView.isHidden = true
        transparencyView.isHidden = true
        defaultColorView.isHidden = true
        paletteView.isHidden = true
        
        cameraRollBtn.isHidden = false
        cameraUnderLine.isHidden = false
        filterBtn.isHidden = false
        filterUnderLine.isHidden = false
        
        cameraRollBtn.tintColor = UIColor.DSColor.lightGreen
        cameraUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        colorBtn.tintColor = UIColor.DSColor.lightGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        transparencyBtn.tintColor = UIColor.DSColor.lightGreen
        transparencyUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
        filterBtn.tintColor = UIColor.DSColor.heavyGreen
        filterUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        
    }
    
    func editShapeMode() {
        
        photoView.isHidden = true
        filterView.isHidden = true
        transparencyView.isHidden = true
        defaultColorView.isHidden = false
        paletteView.isHidden = true
        
        cameraRollBtn.isHidden = true
        cameraUnderLine.isHidden = true
        filterBtn.isHidden = true
        filterUnderLine.isHidden = true
        
        colorBtn.tintColor = UIColor.DSColor.heavyGreen
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

                cameraRollBtn.tintColor = UIColor.DSColor.lightGreen
                
            }
        }
    }
}
