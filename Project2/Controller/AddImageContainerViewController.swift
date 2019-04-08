//
//  AddImageContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/3.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit
import Photos

class AddImageContainerViewController: UIViewController, PhotoManagerDelegate {
    

    @IBOutlet weak var collectionView: UICollectionView!  {
        
        didSet {
            
            collectionView.delegate = self
            
            collectionView.dataSource = self
            
        }
    }
    
    let photoManager = PhotoManager()
    var imageArray = [UIImage]()
    var imageURL = [URL]()
    var cache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        collectionView.al_registerCellWithNib(identifier: String(describing: PhotoCollectionViewCell.self), bundle: nil)
        collectionView.al_registerHeaderViewWithNib(identifier:  String(describing: ImageCollectionReusableView.self), bundle: nil)
        
        setupCollectionViewLayout()
        
        photoManager.delegate = self
        photoManager.grabPhoto()

    }
    func setupImage() {
        collectionView.reloadData()
    }
    
}

extension AddImageContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoCollectionViewCell.self), for: indexPath)
        guard let photoCell = cell as? PhotoCollectionViewCell else {
            return cell
        }
        
        photoCell.photoImage.image = imageArray[indexPath.item]
        
        return photoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let notificationName = Notification.Name(NotiName.addImage.rawValue)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: [NotificationInfo.addImage: imageArray[indexPath.item]])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: ImageCollectionReusableView.self), for: indexPath)
        
        guard let header = reusableView as? ImageCollectionReusableView else { return reusableView }
        
        return header
        
    }
}

extension AddImageContainerViewController {
    
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
