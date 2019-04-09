//
//  ContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/1.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit
import Photos
import Kingfisher
import Fusuma

class ContainerViewController: UIViewController, PhotoManagerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.delegate = self
            
            collectionView.dataSource = self
            
        }
    }

    let photoManager = PhotoManager()
    var imageArray:[UIImage] = []
    
    var imageURL:[URL] = [] 
    
    var cache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.al_registerCellWithNib(identifier: String(describing: PhotoCollectionViewCell.self), bundle: nil)
        collectionView.al_registerHeaderViewWithNib(identifier:  String(describing: CollectionReusableView.self), bundle: nil)

        setupCollectionViewLayout()
        
//        photoManager.delegate = self
//        photoManager.grabPhoto()
        
    }
    
    func setupImage() {
        collectionView.reloadData()
    }
  
}

extension ContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageArray.count
        
//        return imageURL.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoCollectionViewCell.self), for: indexPath)
        guard let photoCell = cell as? PhotoCollectionViewCell else {
            return cell
        }
  
        photoCell.photoImage.image = imageArray[indexPath.item]
  
//        photoCell.photoImage.kf.setImage(with: URL(string: "//var/mobile/Media/DCIM/134APPLE/IMG_4696.JPG"))
        
//        photoCell.photoImage.kf.setImage(with: URL(string: "/Users/alexandra/Library/Developer/CoreSimulator/Devices/8C65DCDA-94F8-471F-A95B-EA18EE6A39A2/data/Media/DCIM/100APPLE/IMG_0001.JPG"))
        
//        print(imageURL[0])
//
//        let fileURL: URL = imageURL[indexPath.item]
//        let provider = LocalFileImageDataProvider(fileURL: fileURL)
//
//        photoCell.photoImage.backgroundColor = UIColor.orange
        
        
        
        
//        photoCell.photoImage.kf.setImage(with: provider)
//        photoCell.photoImage.kf.setImage(with: imageURL[indexPath.item])
        
//        print(photoCell.photoImage.image)
        return photoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let notificationName = Notification.Name(NotiName.changeBackgroundImage.rawValue)
//        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: [NotificationInfo.newImage: imageArray[indexPath.item]])
        
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: [NotificationInfo.newImage: imageURL[indexPath.item]])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: CollectionReusableView.self), for: indexPath)
        
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
