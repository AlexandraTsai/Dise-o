//
//  ShapeContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/14.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class ShapeContainerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var bottomView: UIView! {
        
        didSet {
            
            bottomView.layer.cornerRadius = 50
           
            bottomView.layer.shadowOffset = CGSize(width: -1, height: -1)
            bottomView.layer.shadowColor = UIColor.DSColor.heavyGray.cgColor
            bottomView.layer.shadowRadius = 6
            bottomView.layer.shadowOpacity = 1
             
        }
        
    }

    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.al_registerCellWithNib(identifier: String(describing: ShapeCollectionViewCell.self), bundle: nil)
        setupCollectionViewLayout()
     
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if ShapeAsset.allCases.count%3 == 0 {
            
            return ShapeAsset.allCases.count+1
        }
        
        return ShapeAsset.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            String(describing: ShapeCollectionViewCell.self), for: indexPath)
        
        guard let shapeCell = cell as? ShapeCollectionViewCell else { return cell }
            
            if collectionView.numberOfItems(inSection: 0) > ShapeAsset.allCases.count {
                
                if indexPath.item == ShapeAsset.allCases.count {
                    
                    shapeCell.shapeImage.image = nil
                    
                } else {
                    
                    shapeCell.shapeImage.image = UIImage(named: ShapeAsset.allCases[indexPath.item].rawValue)
                }
            } else {
                 shapeCell.shapeImage.image = UIImage(named: ShapeAsset.allCases[indexPath.item].rawValue)
            }
            
        return shapeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let notificationName = Notification.Name(NotiName.addShape.rawValue)
        
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.addShape: ShapeAsset.allCases[indexPath.item].rawValue])

    }
    
    private func setupCollectionViewLayout() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(
            width: (UIScreen.main.bounds.width-180)/3,
            height: (UIScreen.main.bounds.width-180)/3
               
        )
        
        flowLayout.sectionInset = UIEdgeInsets(top: 10,
                                               left: 30,
                                               bottom: 10,
                                               right: 30)
        
        flowLayout.minimumInteritemSpacing = 60
        
        flowLayout.minimumLineSpacing = 20
        
        collectionView.collectionViewLayout = flowLayout
    }
}
