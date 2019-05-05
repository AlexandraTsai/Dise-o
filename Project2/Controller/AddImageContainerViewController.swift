//
//  AddImageContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/3.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit
import Photos
import Fusuma

class AddImageContainerViewController: UIViewController, PhotoManagerDelegate, FusumaDelegate {

    @IBOutlet weak var collectionView: UICollectionView! {

        didSet {

            collectionView.delegate = self

            collectionView.dataSource = self

        }
    }
    
    deinit {
        print("AddImageContainer is deinit")
    }

    let photoManager = PhotoManager()
    var imageArray = [UIImage]()
    var imageURL = [URL]()
    var cache = NSCache<NSString, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()

//        collectionView.al_registerCellWithNib(identifier: String(describing:
//          PhotoCollectionViewCell.self), bundle: nil)
        
//        collectionView.al_registerHeaderViewWithNib(identifier:  String(describing:
//          ImageCollectionReusableView.self), bundle: nil)
//
//        setupCollectionViewLayout()

//        photoManager.delegate = self
//        photoManager.grabPhoto()

        setupImagePicker()

    }
    func setupImage() {
        collectionView.reloadData()
    }

}

extension AddImageContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {

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

        let notificationName = Notification.Name(NotiName.addImage.rawValue)
        
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.addImage: imageArray[indexPath.item]])

    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        let reusableView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: String(describing: ImageCollectionReusableView.self),
            for: indexPath)

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

    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {

//        designView.image = image

        let notificationName = Notification.Name(NotiName.changeBackground.rawValue)

        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.backgroundIsImage: true])
    }

    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage, source: FusumaMode) {

        print("Called just after FusumaViewController is dismissed.")
    }

    func fusumaVideoCompleted(withFileURL fileURL: URL) {

        print("Called just after a video has been selected.")
    }

    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {

        print("Camera roll unauthorized")
    }

    // Return selected images when you allow to select multiple photos.
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {

        print("Multiple images are selected.")
    }

    // Return an image and the detailed information.
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {

    }

    func setupImagePicker() {

        let fusuma = FusumaViewController()

        fusuma.delegate = self
        fusuma.availableModes = [FusumaMode.library, FusumaMode.camera]
        // Add .video capturing mode to the default .library and .camera modes
        fusuma.cropHeightRatio = 1
        // Height-to-width ratio. The default value is 1, which means a squared-size photo.
        fusuma.allowMultipleSelection = false
        // You can select multiple photos from the camera roll. The default value is false.

        fusumaSavesImage = true

        fusumaTitleFont = UIFont(name: FontName.copperplate.boldStyle(), size: 18)

        fusumaBackgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)

        fusumaCameraRollTitle = "Camera Roll"

        fusumaTintColor = UIColor(red: 244/255, green: 200/255, blue: 88/255, alpha: 1)

        fusumaCameraTitle = "Camera"
        fusumaBaseTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

        self.present(fusuma, animated: true, completion: nil)
    }

}
