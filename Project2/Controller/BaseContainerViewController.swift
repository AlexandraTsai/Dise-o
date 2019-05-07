//
//  BaseContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/7.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class BaseContainerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, BaseViewControllerDelegate {
   
    var imageToBeEdit: [UIImage]?
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterCollectionView: UICollectionView! {
        
        didSet {
            
            filterCollectionView.delegate = self
            filterCollectionView.dataSource = self
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterCollectionView.al_registerCellWithNib(identifier: String(describing: FilterCollectionViewCell.self),
                                                    bundle: nil)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return FilterType.allCases.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: FilterCollectionViewCell.self),
            for: indexPath)
        
        guard let filterCell = cell as? FilterCollectionViewCell else {
            return cell
        }
      
        if let imageToBeEdit = imageToBeEdit {
            
            filterCell.filteredImage.image = imageToBeEdit[indexPath.item]
            
        }
        
        return filterCell
        
    }
    
    func showAllFilter(for image: UIImage) {
        
        imageToBeEdit = image.createASetOfImage()
        
        filterCollectionView.reloadData()
        
    }
    
    func editImageMode() {

        filterView.isHidden = false
        filterCollectionView.isHidden = false

//        filterButton.tintColor = UIColor.DSColor.heavyGreen
//        filterUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
//
//        cameraRollButton.tintColor = UIColor.DSColor.lightGreen
//        cameraUnderLine.backgroundColor = UIColor.DSColor.lightGreen
//
//        colorButton.tintColor = UIColor.DSColor.lightGreen
//        colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen

    }

//    func noImageMode() {
//
//        filterView.isHidden = true
//        filterCollectionView.isHidden = true
//
//        photoView.isHidden = true
//
//        filterButton.tintColor = UIColor.DSColor.lightGreen
//        filterUnderLine.backgroundColor = UIColor.DSColor.lightGreen
//
//        cameraRollButton.tintColor = UIColor.DSColor.lightGreen
//        cameraUnderLine.backgroundColor = UIColor.DSColor.lightGreen
//
//        colorButton.tintColor = UIColor.DSColor.heavyGreen
//        colorUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
//
//    }
    
//    func pickImageMode() {
//
//        filterView.isHidden = true
//        photoView.isHidden = false
//
//        filterButton.tintColor = UIColor.DSColor.lightGreen
//        filterUnderLine.backgroundColor = UIColor.DSColor.lightGreen
//
//        cameraRollButton.tintColor = UIColor.DSColor.heavyGreen
//        cameraUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
//
//        colorButton.tintColor = UIColor.DSColor.lightGreen
//        colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen
//
//    }
    
}
