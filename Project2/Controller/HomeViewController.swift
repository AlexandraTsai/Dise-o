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
    
    var layerArray: [LayerProtocol] = []
    
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
    
    // swiftlint:disable cyclomatic_complexity
    func addAllDesigns() {
        
        for object in 0...designs.count-1 {
            
            //Create designView and setup the background
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
            
            //SubView: Images
            if designs[object].images != nil {
                
                guard let array = designs[object].images else { return }
                
                let subImages = Array(array)
                
                guard let imageArray = subImages as? [Image] else { return }
                
                layerArray.append(contentsOf: imageArray)

            }
            
            //SubView: TextView
            if designs[object].texts != nil {
                
                guard let texts = designs[object].texts else { return }
                
                guard let textArray = Array(texts) as? [Text] else { return }
                
                layerArray.append(contentsOf: textArray)
 
            }
            
            //SubView: ShapeView
            if designs[object].shapes != nil {
                
                guard let shapes = designs[object].shapes else { return }
                
                guard let shapesArray = Array(shapes) as? [Shape] else { return }
                
                layerArray.append(contentsOf: shapesArray)

            }
          
            layerArray.sort {
                
                $0.index < $1.index
            }
      
            for layer in layerArray {
                
                if let view = layer as? Image {
                    
                    guard let frame = view.frame as? CGRect,
                        let image = view.image as? UIImage,
                        let transform = view.transform as? CGAffineTransform else { return }
                    
                    let imageView = ALImageView()
                    
                    imageView.frame = frame
                    
                    imageView.image = image
                    
                    imageView.transform = transform
                    
                    designView.addSubview(imageView)
                    
                } else if let view = layer as? Text {
                    
                    guard let frame = view.frame as? CGRect,
                        let transform = view.transform as? CGAffineTransform,
                        let attributedText = view.attributedText as? NSAttributedString else { return }
                    
                    let textView = ALTextView()
                    
                    textView.frame = frame
                    
                    textView.transform = transform
                    
                    textView.attributedText = attributedText
                    
                    textView.backgroundColor = UIColor.clear
                    
                    designView.addSubview(textView)
                    
                } else if let view = layer as? Shape {
                    
                    guard let shapeView = view.shapView as? ALShapeView else { return }
                    
                    designView.addSubview(shapeView)
                    
                }
            }
          
            alDesignArray.append(designView)
            
            layerArray = []
            
        }
    }
    // swiftlint:enable cyclomatic_complexity
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
        
        showTappedDesign(for: indexPath.item, at: designVC)
        
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

extension HomeViewController {
    
    func showTappedDesign(for index: Int, at designVC: DesignViewController) {
        
        let selectedDesign = alDesignArray[index]
        
        //Design View
        designVC.designView.backgroundColor = selectedDesign.backgroundColor
        
        designVC.designView.image = selectedDesign.image
        
        designVC.designView.createTime = selectedDesign.createTime
        
        for subView in selectedDesign.subviews {
            
             designVC.designView.addSubview(subView)
        }
        
    }
}
