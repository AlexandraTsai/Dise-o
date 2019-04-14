//
//  ShapeContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/14.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class ShapeContainerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

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
        
        return ShapeAsset.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            String(describing: ShapeCollectionViewCell.self), for: indexPath)
        
        guard let shapeCell = cell as? ShapeCollectionViewCell else { return cell }
            
        shapeCell.shapeImage.image = UIImage(named: ShapeAsset.allCases[indexPath.item].rawValue)
        
        return shapeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let notificationName = Notification.Name(NotiName.addShape.rawValue)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        shapeLayer.fillColor = UIColor.orange.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.strokeColor = UIColor.black.cgColor
        let arcCenter:CGPoint = shapeLayer.position // 設定圓心
        let radius:CGFloat = 100 // 設定半徑
        
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: 0, endAngle: CGFloat(2 * Float.pi), clockwise: true)
        
        shapeLayer.path = path.cgPath
        
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.addShape: shapeLayer])
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
