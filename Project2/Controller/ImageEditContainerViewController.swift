//
//  ImageEditContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/7.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit
import HueKit

class ImageEditContainerViewController: UIViewController, PhotoManagerDelegate {
    
    @IBOutlet weak var cameraRollBtn: UIButton!
    @IBOutlet weak var colorBtn: UIButton!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var transparencyBtn: UIButton!
    
    @IBOutlet weak var paletteView: UIView!
    @IBOutlet weak var colorSquarePicker: ColorSquarePicker!
    @IBOutlet weak var colorBarPicker: ColorBarPicker!
    @IBOutlet weak var usedColorButton: UIButton!
    
    @IBOutlet weak var imageCollectionView: UICollectionView! {

        didSet {
            imageCollectionView.delegate = self
            imageCollectionView.dataSource = self
        }
    }

    let photoManager = PhotoManager()
    var imageArray = [UIImage]()
    var imageURL = [URL]()
    var cache = NSCache<NSString, UIImage>()
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        paletteView.isHidden = true
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

//        photoManager.delegate = self
//        photoManager.grabPhoto()

//         imageCollectionView.al_registerCellWithNib(
//             identifier: String(describing: PhotoCollectionViewCell.self),
//             bundle: nil)

//        setupCollectionViewLayout()
        
        createNotification()
        
        filterBtn.isSelected = true
    }
    
    func setupImage() {
        imageCollectionView.reloadData()
    }
    
    @IBAction func cameraRollBtnTapped(_ sender: Any) {
        
        cameraRollBtn.isSelected = true
        colorBtn.isSelected = false
        filterBtn.isSelected = false
        transparencyBtn.isSelected = false
        
        let notificationName = Notification.Name(NotiName.changeImage.rawValue)
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.changeImage: true])
        
    }
    @IBAction func colorsBtnTapped(_ sender: Any) {
        
        cameraRollBtn.isSelected = false
        colorBtn.isSelected = true
        filterBtn.isSelected = false
        transparencyBtn.isSelected = false
    }
    
    @IBAction func filterBtnTapped(_ sender: Any) {
        cameraRollBtn.isSelected = false
        colorBtn.isSelected = false
        filterBtn.isSelected = true
        transparencyBtn.isSelected = false
    }

    @IBAction func transparencyBtnTapped(_ sender: Any) {
        
        cameraRollBtn.isSelected = false
        colorBtn.isSelected = false
        filterBtn.isSelected = false
        transparencyBtn.isSelected = true
    }
    @IBAction func usedColorBtnTapped(_ sender: Any) {
        
        paletteView.isHidden = false
        
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
        
        print(colorSquarePicker.hue)
        
        let notificationName = Notification.Name(NotiName.changeEditingViewColor.rawValue)
        
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.changeEditingViewColor: colorSquarePicker.color])
        
        usedColorButton.backgroundColor = colorSquarePicker.color
    }
    
    @IBAction func colorSquarePickerValueChanged(_ sender: ColorSquarePicker) {
       
        let notificationName = Notification.Name(NotiName.changeEditingViewColor.rawValue)
        
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.changeEditingViewColor: sender.color])
        
        usedColorButton.backgroundColor = sender.color
    }
    
    @IBAction func checkBtnTapped(_ sender: Any) {
        
        paletteView.isHidden = true
        
        let notificationName = Notification.Name(NotiName.addElementButton.rawValue)
        
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.addElementButton: true])
    }
    
}

extension ImageEditContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: PhotoCollectionViewCell.self),
            for: indexPath)
        
        guard let photoCell = cell as? PhotoCollectionViewCell else { return cell }
        photoCell.photoImage.image = imageArray[indexPath.item]

        return photoCell
    }

}

extension ImageEditContainerViewController {

    private func setupCollectionViewLayout() {

        let flowLayout = UICollectionViewFlowLayout()

        flowLayout.itemSize = CGSize(
            width: UIScreen.main.bounds.width/4,
            height: UIScreen.main.bounds.width/4
        )

        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        flowLayout.minimumInteritemSpacing = 0

        flowLayout.minimumLineSpacing = 0

        flowLayout.headerReferenceSize = CGSize(width: imageCollectionView.frame.width, height: 40) // header zone

        imageCollectionView.collectionViewLayout = flowLayout
    }
}

extension ImageEditContainerViewController {
    
    //Notification for image picked
    func createNotification() {
        
        // 註冊addObserver
        let notificationName = Notification.Name(NotiName.didChangeImage.rawValue)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeImage(noti:)), name: notificationName, object: nil)
        
        let notificationName2 = Notification.Name(NotiName.paletteColor.rawValue)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(changePaletteColor(noti:)), name: notificationName2, object: nil)
    }
    
    // 收到通知後要執行的動作
    @objc func changeImage(noti: Notification) {
        if let userInfo = noti.userInfo,
            let mode = userInfo[NotificationInfo.didChangeImage] as? Bool {
            
            if mode == true {
               filterBtn.isSelected = true
               cameraRollBtn.isSelected = false
            }
        }
    }
    
    @objc func changePaletteColor(noti: Notification) {
        if let userInfo = noti.userInfo,
            let color = userInfo[NotificationInfo.paletteColor] as? UIColor {
       
//            colorSquarePicker.hue = 0.3349206349206349
//            colorBarPicker.hue = 0.3349206349206349
        }
    }
}

