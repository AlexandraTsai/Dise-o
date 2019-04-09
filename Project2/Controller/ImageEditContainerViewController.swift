//
//  ImageEditContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/7.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class ImageEditContainerViewController: UIViewController, PhotoManagerDelegate {

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
    }
    func setupImage() {
        imageCollectionView.reloadData()
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
