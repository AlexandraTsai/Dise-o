//
//  HomeViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/18.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.delegate = self
            
            collectionView.dataSource = self
            
        }
    }
    
    var newDesignView = NewDeign()
    
    var alDesignArray: [ALDesignView] = []
    
    var designs: [Design] = [] {
        
        didSet {
            
            if designs.count == 0 {
                
                alDesignArray = []
                
            } else {
             
                addAllDesigns()
               
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
        
        collectionView.reloadData()
        
        designs = []
        
        fetchData()
        
        if designs.count == 0 {
            
            collectionView.isHidden = true
            
        } else {
            
            collectionView.isHidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(newDesignView)
        newDesignView.isHidden = true
        
        collectionView.al_registerCellWithNib(
            identifier: String(describing: PortfolioCollectionViewCell.self),
            bundle: nil)
        
        setupCollectionViewLayout()

    }
 
    @IBAction func addButtonTapped(_ sender: UIButton) {
        self.setupInputView()
        newDesignView.alpha = 0
   
        UIView.animate(withDuration: 0.7, animations: {
            self.newDesignView.alpha = 1
          
        })
        
        newDesignView.textField.delegate = self
        newDesignView.textField.becomeFirstResponder()
      
    }
    
    func setupInputView() {
        
        newDesignView.isHidden = false

        //Auto Layout
        newDesignView.translatesAutoresizingMaskIntoConstraints = false
        
        newDesignView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        newDesignView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        newDesignView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        newDesignView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
 
        newDesignView.cancelButton.addTarget(self,
                                             action: #selector(cancelButtonTapped(sender:)),
                                             for: .touchUpInside)
        newDesignView.confirmButton.addTarget(self,
                                              action: #selector(confirmButtonTapped(sender:)),
                                              for: .touchUpInside)
       
    }
    
    @objc func cancelButtonTapped(sender: UIButton) {
        
        UIView.animate(withDuration: 0.7, animations: {
            
            self.newDesignView.isHidden = true
            
            //To hide the keyboard
            self.view.endEditing(true)
            
        })
       
    }
    
    @objc func confirmButtonTapped(sender: UIButton) {
        
        newDesignView.isHidden = true
        
        //To hide the keyboard
        self.view.endEditing(true)
        
        guard let designVC = UIStoryboard(
            name: "Main",
            bundle: nil).instantiateViewController(
                withIdentifier: String(describing: DesignViewController.self)) as? DesignViewController
            else { return }
        
        guard let text = newDesignView.textField.text else { return }
        
        designVC.loadViewIfNeeded()
        
        designVC.designView.designName = text
        
        show(designVC, sender: nil)
        
    }
    
    func setupNavigationBar() {
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    func fetchData() {
        
        StorageManager.shared.fetchDesigns(completion: { result in
            
            switch result {
                
            case .success(let designs):
                
                self.designs = designs
                
            case .failure(_):
                
                print("讀取資料發生錯誤")
            }
        })
    }
    
    func addAllDesigns() {
        
        for object in 0...designs.count-1 {
            
            let designView = ALDesignView()
            
            guard let frame = designs[object].frame as? CGRect,
                let designName = designs[object].designName else { return }
            
            designView.frame = frame
            
            designView.createTime = designs[object].createTime
            
            designView.designName = designName
            
            if designs[object].backgroundColor != nil {
                
                guard let color = designs[object].backgroundColor as? UIColor else { return }
                
                designView.backgroundColor = color
                
            }
            
            if designs[object].backgroundImage != nil {
                
                guard let backgroundImage = designs[object].backgroundImage as? UIImage else { return }
                
                designView.image = backgroundImage
                
            }
            
            if designs[object].images != nil {
                
                guard let array = designs[0].images else { return }
                
                let subImages = Array(array)
                
                guard let alArray = subImages as? [Image] else { return }
      
                for image in alArray {
                    
                    let imageView = ALImageView(frame: CGRect(x: 30, y: 20, width: 100, height: 100))
                    
                    guard let image = image.image as? UIImage else { return }
                    
                    imageView.image = image
                    
                    designView.addSubview(imageView)
                    
                }
                
            }
            
            alDesignArray.append(designView)
            
        }
    }
}

extension HomeViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return alDesignArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: PortfolioCollectionViewCell.self),
            for: indexPath)
        
        guard let portfolioCell = cell as? PortfolioCollectionViewCell else { return cell }
            
        let design = alDesignArray[indexPath.item]
            
        if design.image == nil {
            
            portfolioCell.designView.backgroundColor = design.backgroundColor
            portfolioCell.designView.image = nil
            
        } else {
            
            portfolioCell.designView.image = design.image
        }
        
        return portfolioCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let designVC = UIStoryboard(
            name: "Main",
            bundle: nil).instantiateViewController(
                withIdentifier: String(describing: DesignViewController.self)) as? DesignViewController
            else { return }
        
        designVC.loadViewIfNeeded()
        
        let selectedDesign = alDesignArray[indexPath.item]
        
        designVC.designView.backgroundColor = selectedDesign.backgroundColor
        
        designVC.designView.image = selectedDesign.image
        
        designVC.designView.createTime = selectedDesign.createTime
        
        if alDesignArray[indexPath.row].subImages.count > 0 {
            
            for count in 0...selectedDesign.subImages.count-1 {
                
                let view = selectedDesign.subImages[count]
                
                print(view.index)
                
                designVC.designView.insertSubview(view, at: view.index)
                
            }
            
        }
        
        show(designVC, sender: nil)
    }
    
    private func setupCollectionViewLayout() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(
            width: (UIScreen.main.bounds.width-60)/2,
            height: (UIScreen.main.bounds.width-60)/2
        )
        
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        flowLayout.minimumLineSpacing = 20
        
        flowLayout.minimumInteritemSpacing = 20
        
        collectionView.collectionViewLayout = flowLayout
    }
    
}
