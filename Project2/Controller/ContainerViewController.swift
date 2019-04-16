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

class ContainerViewController: UIViewController, PhotoManagerDelegate {

    @IBOutlet weak var colorSquarePicker: ColorSquarePicker!
    @IBOutlet weak var colorIndicatorView: ColorIndicatorView!
    
    @IBOutlet weak var cameraRollButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!

    @IBOutlet weak var collectionView: UICollectionView! {

        didSet {

            collectionView.delegate = self

            collectionView.dataSource = self

        }
    }

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

        let notificationName = Notification.Name(NotiName.pickingPhotoMode.rawValue)
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.pickingPhotoMode: true])

    }

    @IBAction func filterBtnTapped(_ sender: Any) {

        filterButton.isSelected = true
        colorButton.isSelected = false
    }

    @IBAction func colorBtnTapped(_ sender: Any) {

        filterButton.isSelected = false
        colorButton.isSelected = true
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
                filterButton.isHidden = false
                filterButton.isSelected = true
                colorButton.isSelected = false
            } else {
                filterButton.isHidden = true
                colorButton.isSelected = true
            }
        }
    }
}
