//
//  ImageEditContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/7.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class ImageEditContainerViewController: UIViewController, PhotoManagerDelegate {
    
    @IBOutlet weak var cameraRollBtn: UIButton!
    @IBOutlet weak var colorBtn: UIButton!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var transparencyBtn: UIButton!
    
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

    override func viewDidLoad() {
        
        super.viewDidLoad()

//        photoManager.delegate = self
//        photoManager.grabPhoto()

        imageCollectionView.al_registerCellWithNib(
            identifier: String(describing: PhotoCollectionViewCell.self),
            bundle: nil)

        setupCollectionViewLayout()
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
}