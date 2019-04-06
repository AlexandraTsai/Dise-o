//
//  ContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/1.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit
import Photos

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.delegate = self
            
            collectionView.dataSource = self
            
        }
    }
    
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.al_registerCellWithNib(identifier: String(describing: PhotoCollectionViewCell.self), bundle: nil)
        collectionView.al_registerHeaderViewWithNib(identifier:  String(describing: CollectionReusableView.self), bundle: nil)
        
        setupCollectionViewLayout()
        
//        grabPhoto()
    }
    
}

extension ContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
   
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
        
        let notificationName = Notification.Name(NotiName.changeBackgroundImage.rawValue)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: [NotificationInfo.newImage: imageArray[indexPath.item]])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: CollectionReusableView.self), for: indexPath)
        
        guard let header = reusableView as? CollectionReusableView else { return reusableView }
        
        return header
        
    }
}

extension ContainerViewController {
    
    func grabPhoto() {
        
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
            
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count {
                    
                    guard let asset = fetchResult.object(at: i) as? PHAsset else { return }
                    
                    imgManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: requestOptions) { (image, error) in
                        
                        guard let image = image else { return }
                        
                        self.imageArray.append(image)
                        
                    }
                }
            } else {
                print("You got no photos!")
                self.collectionView.reloadData()
            }
        }
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
