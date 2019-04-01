//
//  SelectionTableViewCell.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/1.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.al_registerCellWithNib(identifier: String(describing: SelectorCollectionViewCell.self), bundle: nil)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SelectorCollectionViewCell.self), for: indexPath)
        
        guard let selectorCell = cell as? SelectorCollectionViewCell else {
            return cell
        }
        
        switch indexPath.item {
        case 0:
            selectorCell.label.text = "Camera Roll"
            print("item0 width: \(cell.frame.width)")
            print("UIScreen width/2: \(UIScreen.main.bounds.width/2)")
            
        default:
             selectorCell.label.text = "Colors item"
        }
       
        return selectorCell
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width/2
        let height: CGFloat = 50.0
        
        return CGSize(width: width, height: height)
    }
    

}
