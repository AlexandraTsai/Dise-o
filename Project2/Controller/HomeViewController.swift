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
    
    @IBOutlet weak var addDesignButton: UIButton!
    
    var selectedCell: Int?
    
    var newDesignView = NewDeign()
    
    let selectionView = SelectionView()
    
    var layerArray: [LayerProtocol] = []
    
    var alDesignArray: [ALDesignView] = []
    
    var designs: [Design] = [] {
        
        didSet {
            
            if designs.count == 0 {
                
                collectionView.isHidden = true
                
                alDesignArray = []
                
            } else {
                
                collectionView.isHidden = false
             
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
        
        addDesignButton.alpha = 1
        selectionView.alpha = 0
        selectionView.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(newDesignView)
        newDesignView.isHidden = true
        
        collectionView.al_registerCellWithNib(
            identifier: String(describing: PortfolioCollectionViewCell.self),
            bundle: nil)
        
        setupCollectionViewLayout()
        
        selectionView.addOn(self.view)
        
        selectionView.closeButton.addTarget(self, action: #selector(self.closeBtnTapped(sender:)), for: .touchUpInside)
        
        selectionView.cancelButton.addTarget(self, action: #selector(closeBtnTapped(sender:)), for: .touchUpInside)
        
        selectionView.deleteButton.addTarget(self, action: #selector(deleteBtnTapped(sender:)), for: .touchUpInside)
        
        selectionView.openButton.addTarget(self, action: #selector(openBtnTapped(sender:)), for: .touchUpInside)
    }
 
    @IBAction func addButtonTapped(_ sender: UIButton) {
        self.setupInputView()
        newDesignView.alpha = 0
        newDesignView.textField.text = ""
   
        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            self?.newDesignView.alpha = 1
          
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
        
        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            
            self?.newDesignView.isHidden = true
            
            //To hide the keyboard
            self?.view.endEditing(true)
            
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
                
                guard let fileName = designs[object].backgroundImage else { return }
                
                let backgroundImage = loadImageFromDiskWith(fileName: fileName)
                
                designView.image = backgroundImage
                
                designView.imageFileName = fileName
                
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
          
            layerArray.sort { $0.index < $1.index }
      
            for layer in layerArray {
                
                if let view = layer as? Image {
                    
                    guard let frame = view.frame as? CGRect,
                        let fileName = view.image,
                        let transform = view.transform as? CGAffineTransform else { return }
                    
                    let imageView = ALImageView()
                    
                    imageView.frame = frame
                   
                    imageView.transform = transform
                    
                    let image = loadImageFromDiskWith(fileName: fileName)
                    
                    imageView.image = image
                    
                    imageView.imageFileName = fileName
                    
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
                    
                    if let shapeType = view.shapeType, let color = view.shapeColor as? UIColor {
                        
                        shapeView.shapeType = shapeType
                        
                        shapeView.shapeColor = color
                        
                        shapeView.stroke = view.stroke

                    }
                   
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
            
        portfolioCell.btnTapAction = { [weak self] in
            
            self?.selectedCell = indexPath.item
            
            self?.addDesignButton.alpha = 0
            
            UIView.animate(withDuration: 0.7, animations: { [weak self] in
                
                self?.selectionView.alpha = 1
                
                self?.selectionView.isHidden = false

            })
            
        }

        return portfolioCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let cell = collectionView.cellForItem(at: indexPath)
//
//        guard let portfolioCell = cell as? PortfolioCollectionViewCell else { return }
        
//        guard let subViews = cell?.subviews else { return }
        
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
    
    func showTappedDesign(for index: Int,
                          at designVC: DesignViewController) {
        
        let selectedDesign = alDesignArray[index]
        
        //Design View
        designVC.designView.backgroundColor = selectedDesign.backgroundColor
        
        designVC.designView.image = selectedDesign.image
        
        designVC.designView.imageFileName = selectedDesign.imageFileName
        
        designVC.designView.createTime = selectedDesign.createTime
        
        for subView in selectedDesign.subviews {

            designVC.designView.addSubview(subView)

            designVC.addAllGesture(to: subView)
        }

    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory,
                                                        userDomainMask,
                                                        true)
        
        if let dirPath = paths.first {
            
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            
            let image = UIImage(contentsOfFile: imageUrl.path)
            
            return image
            
        }
        
        return nil
    }
   
    @objc func closeBtnTapped(sender: UIButton) {
        
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            
            self?.selectionView.alpha = 0
            
            self?.addDesignButton.alpha = 1
            
        })
    }
    
    @objc func deleteBtnTapped(sender: UIButton) {
        
        guard let index = selectedCell else { return }
        
        StorageManager.shared.deleteDesign(designs[index],
                                           completion: { result in
                                            
                                            switch result {
                                                
                                            case .success(_):
                                                
                                                designs.remove(at: index)
                                                
                                            case .failure(_):
                                                
                                                print("Fail to delete.")
                                                
                                            }
            
        })
    
        fetchData()
        
        collectionView.reloadData()
        selectionView.alpha = 0
        
        addDesignButton.alpha = 1
        
    }
    
    @objc func openBtnTapped(sender: UIButton) {
        
       guard let designVC = UIStoryboard(name: "Main",bundle: nil)
        .instantiateViewController(withIdentifier: String(describing: DesignViewController.self)) as? DesignViewController else { return }
      
        designVC.loadViewIfNeeded()
        
        guard let index = selectedCell else { return }
        
        showTappedDesign(for: index, at: designVC)
        
        show(designVC, sender: nil)
    }
}
