//
//  HomeViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/18.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit
import CoreData
import Crashlytics

// swiftlint:disable file_length
class HomeViewController: BaseViewController, UITextFieldDelegate,
                        UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.delegate = self
            
            collectionView.dataSource = self
            
        }
    }
    
    @IBOutlet weak var addDesignButton: UIButton!
    
    @IBOutlet weak var hintButton: UIButton! {
        
        didSet {
            
            hintButton.titleLabel?.textAlignment = .center
            
        }
        
    }
    
    var selectedCell: Int?
    
    let alertLabel = SaveSuccessLabel()
    
    let renameView = RenameView()
    
    var newDesignView = NewDeign()
    
    let selectionView = SelectionView()
    
    let deleteView = DeleteView()
   
    var layerArray: [LayerProtocol] = []
    
    var alDesignArray: [ALDesignView] = []
    
    var designs: [Design] = [] {
        
        didSet {
            
            if designs.count == 0 {
                
                collectionView.isHidden = true
                
                alDesignArray = []
                
            } else {
                
                alDesignArray = []
                
                collectionView.isHidden = false
             
                addAllDesigns()
               
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
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
        renameView.alpha = 0
        selectionView.isHidden = true
        deleteView.alpha = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        renameView.addOn(self.view)
        self.view.addSubview(newDesignView)
        self.view.addSubview(alertLabel)
        self.view.addSubview(renameView)
        newDesignView.isHidden = true
        alertLabel.alpha = 0
        
        collectionView.al_registerCellWithNib(
            identifier: String(describing: PortfolioCollectionViewCell.self),
            bundle: nil)
        
        setupCollectionViewLayout()
        
        selectionView.addOn(self.view)
        deleteView.addOn(self.view)
        
        selectionView.closeButton.addTarget(self, action: #selector(self.closeBtnTapped(sender:)), for: .touchUpInside)
        
        selectionView.cancelButton.addTarget(self, action: #selector(closeBtnTapped(sender:)), for: .touchUpInside)
        
        selectionView.deleteButton.addTarget(self, action: #selector(showDeleteView(sender:)), for: .touchUpInside)
        
        selectionView.openButton.addTarget(self, action: #selector(openBtnTapped(sender:)), for: .touchUpInside)
        
        selectionView.saveButton.addTarget(self, action: #selector(saveImageBtnTapped(sender:)), for: .touchUpInside)
        
        selectionView.shareButton.addTarget(self, action: #selector(shareBtnTapped(sender:)), for: .touchUpInside)
        
        selectionView.renameButton.addTarget(self, action: #selector(renameBtnTapped(sender:)), for: .touchUpInside)
        
        renameView.saveButton.addTarget(self, action: #selector(saveNameBtnTapped(sender:)), for: .touchUpInside)
        
        renameView.cancelButton.addTarget(self, action: #selector(cancelRename(sender:)), for: .touchUpInside)
        
        deleteView.deleteButton.addTarget(self, action: #selector(deleteBtnTapped(sender:)), for: .touchUpInside)
        
        deleteView.cancelButton.addTarget(self, action: #selector(closeBtnTapped(sender:)), for: .touchUpInside)
        
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        self.setupInputView() 
        newDesignView.alpha = 0
        newDesignView.textField.text = ""
        
        newDesignView.textField.delegate = self
   
        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            
            self?.newDesignView.alpha = 1
          
        })

        newDesignView.textField.becomeFirstResponder()
      
    }
    
    func setupInputView() {
        
        newDesignView.isHidden = false

        //Auto Layout
        newDesignView.translatesAutoresizingMaskIntoConstraints = false
        
        newDesignView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        newDesignView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        newDesignView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        let topConstant = (100/667)*UIScreen.main.bounds.height
    
        newDesignView.topAnchor.constraint(equalTo: self.view.topAnchor,
                                           constant: topConstant).isActive = true
        
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
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

    }
    
    func fetchData() {
        
        StorageManager.shared.fetchDesigns(completion: { result in
            
            switch result {
                
            case .success(let designs):
                
                self.designs = designs
              
            case .failure:
                
                print("讀取資料發生錯誤")
            }
        })
    }
    
    // swiftlint:disable cyclomatic_complexity
    func addAllDesigns() {
        
        for object in 0...designs.count-1 {
            
            //Create designView and setup the background
            let designView = ALDesignView()
            
            designs[object].transformDesign(for: designView)
            
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
                    
                   view.transformImage(for: designView)
                    
                } else if let view = layer as? Text {
                    
                    view.transformText(for: designView)
                    
                } else if let view = layer as? Shape {
                    
                    view.transformShape(for: designView)
                }
            }
          
            alDesignArray.append(designView)
            
            layerArray = []
            
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let maxLength = 20
        
        let currentString: NSString = textField.text! as NSString
        
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
        
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
 
        guard let fileName = design.screenshotName else { return cell }
        
        let screenshot = loadImageFromDiskWith(fileName: fileName)
        
        portfolioCell.designView.image = screenshot
            
        portfolioCell.designNameLabel.text = design.designName
            
        portfolioCell.btnTapAction = { [weak self] in
            
            self?.selectedCell = indexPath.item
            
            self?.selectionView.isHidden = false
            
            self?.addDesignButton.alpha = 0
            
            UIView.animate(withDuration: 0.7, animations: { [weak self] in
                
                self?.selectionView.alpha = 1

            })
            
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
            height: (UIScreen.main.bounds.width-60)/2+31
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
       
        designVC.designView.imageFileName = selectedDesign.imageFileName
        
        designVC.designView.createTime = selectedDesign.createTime
        
        designVC.designView.designName = selectedDesign.designName
        
        designVC.designView.alpha = selectedDesign.alpha
        
        if let filter = selectedDesign.filterName {
            
            designVC.designView.image = selectedDesign.image?.addFilter(filter: filter)

        } else {
            
            designVC.designView.image = selectedDesign.image
        }
       
        for subView in selectedDesign.subviews {

            designVC.designView.addSubview(subView)

            designVC.addAllGesture(to: subView)
        }

    }
   
    @objc func closeBtnTapped(sender: UIButton) {
        
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            
            self?.selectionView.alpha = 0
            
            self?.deleteView.alpha = 0
            
            self?.addDesignButton.alpha = 1
            
        })
    }
    
    @objc func showDeleteView(sender: UIButton) {
        
        selectionView.alpha = 0
        addDesignButton.alpha = 1
                
        deleteView.alpha = 1
    }
    
    @objc func deleteBtnTapped(sender: UIButton) {
        
        guard let index = selectedCell else { return }
        
        StorageManager.shared.deleteDesign(designs[index],
                                           completion: { result in
                                            
                                            switch result {
                                                
                                            case .success:
                                                
                                                fetchData()
                                                
                                                collectionView.reloadData()
                                                
                                            case .failure:
                                                
                                                print("Fail to delete.")
                                                
                                            }
            
        })
        
        deleteView.alpha = 0
      
    }
    
    @objc func openBtnTapped(sender: UIButton) {
        
       guard let designVC =
        UIStoryboard(name: "Main",
                     bundle: nil).instantiateViewController(withIdentifier:
            String(describing: DesignViewController.self)) as? DesignViewController else { return }
      
        designVC.loadViewIfNeeded()
        
        guard let index = selectedCell else { return }
        
        showTappedDesign(for: index, at: designVC)
        
        show(designVC, sender: nil)
    }
    
    @objc func saveImageBtnTapped(sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            
            self?.selectionView.alpha = 0
            self?.addDesignButton.alpha = 1
            
        }
        
        guard let index = selectedCell else { return}
        
        guard let screenshot = alDesignArray[index].screenshotName else { return }
        
        guard let image = loadImageFromDiskWith(fileName: screenshot) else { return}
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_: didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func shareBtnTapped(sender: UIButton) {
        
        guard let index = selectedCell else { return}
        
        guard let screenshot = alDesignArray[index].screenshotName else { return }
        
        guard let image = loadImageFromDiskWith(fileName: screenshot) else { return}
        
        let imageToShare = [image]
        
        let activityController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        
        activityController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityController, animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if error != nil {
            
            let alertLabel = SaveSuccessLabel()
            
            self.view.addSubview(alertLabel)
            alertLabel.setupLabel(on: self, with: "Fail to save image")
            
        } else {
            
            alertLabel.setupLabel(on: self, with: "Saved to camera roll")
            
            UIView.animate(withDuration: 0.4,
                           animations: {[weak self] in
                
                 self?.alertLabel.alpha = 1
                
                }, completion: { done in
                    
                    if done {
                        
                        UIView.animate(withDuration: 0.5,
                                       delay: 1.0,
                                       animations: { [weak self] in
                                        
                            self?.alertLabel.alpha = 0
                            
                        })
                        
                    }
                   
            })
            
        }
    }
   
    @objc func renameBtnTapped(sender: UIButton) {
        
        guard let index = selectedCell else { return }
        
        let oldName = alDesignArray[index].designName
        
        renameView.textField.text = oldName
        
        UIView.animate(withDuration: 0.5) { [weak self] in
        
            self?.renameView.alpha = 1
            
            self?.renameView.textField.becomeFirstResponder()
            
            self?.renameView.textField.delegate = self
        }
      
        selectionView.alpha = 0
    }
    
    @objc func saveNameBtnTapped(sender: UIButton) {
        
        self.view.endEditing(true)
        
        addDesignButton.alpha = 1
        
        guard let index = selectedCell,
            let newName = renameView.textField.text else { return }
        
        let design = alDesignArray[index]
        
        design.designName = newName

        guard let createTime = design.createTime else { return }
        
        StorageManager.shared.updateDesign(design: design,
                                           createTime: createTime,
                                           completion: { result in
            
            switch result {
                
            case .success:
                
                fetchData()
                collectionView.reloadData()
                renameView.alpha = 0
                
            case .failure:
                
                print("Fail to rename")
            }
        })
    }
    
    @objc func cancelRename(sender: UIButton) {
        
        renameView.alpha = 0
        addDesignButton.alpha = 1
        
        self.view.endEditing(true)
    }
}
// swiftlint:enable file_length
