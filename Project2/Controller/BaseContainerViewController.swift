//
//  BaseContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/7.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit
import HueKit

protocol BaseContainerViewControllerProtocol: AnyObject {
    
    func showPhotoLibrayAlert()
    func showCameraAlert()
    func changeImageWith(filter: FilterType?)
    
}

class BaseContainerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
BaseViewControllerProtocol {
    
    weak var delegate: BaseContainerViewControllerProtocol?
   
    var imageToBeEdit: [UIImage]?
    
    @IBOutlet weak var photoView: UIView!
    
    @IBOutlet weak var colorSquarePicker: ColorSquarePicker!
    @IBOutlet weak var colorBarPicker: ColorBarPicker!
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterCollectionView: UICollectionView! {
        
        didSet {
            
            filterCollectionView.delegate = self
            filterCollectionView.dataSource = self
            
        }
    }
    
    @IBOutlet weak var cameraRollButton: UIButton! {
        
        didSet {
            
            cameraRollButton.setImage(ImageAsset.Icon_image.imageTemplate, for: .normal)
            
            cameraRollButton.tintColor = UIColor.DSColor.heavyGreen
            
        }
    }
    
    @IBOutlet weak var cameraUnderLine: UIView! {
        
        didSet {
            
            cameraUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
            
        }
        
    }
    
    @IBOutlet weak var filterButton: UIButton! {
        
        didSet {
            
            filterButton.setImage(ImageAsset.Icon_filter.imageTemplate, for: .normal)
            
            filterButton.tintColor = UIColor.DSColor.heavyGreen
            
        }
        
    }
    
    @IBOutlet weak var filterUnderLine: UIView! {
        
        didSet {
            
            filterUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        }
        
    }
    
    @IBOutlet weak var colorButton: UIButton! {
        
        didSet {
            
            colorButton.setImage(ImageAsset.Icon_color.imageTemplate, for: .normal)
            
            colorButton.tintColor = UIColor.DSColor.lightGreen
            
        }
    }
    
    @IBOutlet weak var colorUnderLine: UIView! {
        
        didSet {
            
            colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterCollectionView.al_registerCellWithNib(identifier: String(describing: FilterCollectionViewCell.self),
                                                    bundle: nil)

        setupCollectionViewLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return FilterType.allCases.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            
            delegate?.changeImageWith(filter: nil)
            
        } else {
            
            delegate?.changeImageWith(filter: FilterType.allCases[indexPath.item-1])
            
        }
        
    }
    
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

    func showAllFilter(for image: UIImage) {
        
        imageToBeEdit = image.createASetOfImage()
        
        filterCollectionView.reloadData()
        
    }
    
    func editImageMode() {
        
        filterView.isHidden = false
        filterCollectionView.isHidden = false
        
    }
    
    func editShapeMode() {}
    
    func noImageMode() {}
    
    func pickImageMode() {}
    
}
