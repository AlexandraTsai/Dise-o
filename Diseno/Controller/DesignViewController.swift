//
//  ViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/1.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos
import Fusuma

class DesignViewController: BaseViewController, UITextViewDelegate {

    @IBOutlet weak var designView: ALDesignView! {
        
        didSet {
            
            guard let fileName = designView.imageFileName else { return }
            
            guard let image = loadImageFromDiskWith(fileName: fileName) else { return }
            
            delegate?.showAllFilter(for: image)
            
        }
        
    }
    
    @IBOutlet weak var containerView: BackgroundContainerViewController!
    
    @IBOutlet weak var addElementView: UIView!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var hintView: UIView!

    @IBOutlet weak var addImageContainerView: UIView!
    @IBOutlet weak var addShapeContainerView: UIView!
    
    @IBOutlet weak var addButton: UIButton! {

        didSet {
            addButton.layer.cornerRadius = addButton.frame.width/2
            addButton.clipsToBounds = true
            addButton.setImage(ImageAsset.Icon_add_button.imageTemplate, for: .normal)
            addButton.tintColor = UIColor.DSColor.yellow
            addButton.backgroundColor = UIColor.white
            
        }
    }
    @IBOutlet weak var textView: ALTextView!

    var viewModel: DesignViewModel?
        
    var addingNewImage = false
    var showFilter = true
  
    let saveImageAlert = GoSettingAlertView()
  
    let saveSuccessLabel = SaveSuccessLabel()
    
    let openLibraryAlert = GoSettingAlertView()

    let openCameraAlert = GoSettingAlertView()
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
     
        notAddingTextMode()

        addImageContainerView.isHidden = true
        addShapeContainerView.isHidden = true
        
        addElementView.isHidden = true
        addButton.transform = CGAffineTransform(rotationAngle: 0)
        
        self.tabBarController?.tabBar.barTintColor = UIColor.clear
        
        changeSelector()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addGesture(to: designView, action: #selector(designViewClicked(_:)))

        setupNavigationBar()

        addElementView.isHidden = true

        self.view.addSubview(saveSuccessLabel)
        self.view.addSubview(openLibraryAlert)
        self.view.addSubview(openCameraAlert)
        
        saveSuccessLabel.alpha = 0
        openLibraryAlert.alpha = 0
        openCameraAlert.alpha = 0

        bindViewModel()
    }
    
    override func fusumaClosed() {
        
        showFilter = false
        
        delegate?.pickImageMode()
        
    }
    
    override func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        showFilter = true
        
        let fileName = String(Date().timeIntervalSince1970)
        
        saveImage(fileName: fileName, image: image)
        
        if addingNewImage == true {
            
            let newImage = ALImageView(frame: CGRect(x: designView.frame.width/2-75,
                                                     y: designView.frame.height/2-75,
                                                     width: 150,
                                                     height: 150))
            
            DispatchQueue.main.async { [ weak newImage ] in
                
                newImage?.image = image
            }
            
            newImage.imageFileName = fileName
            
            newImage.originImage = image
            
            designView.addSubview(newImage)
            
            goToEditingVC(with: newImage, navigationBarForImage: true)
            
            addingNewImage = false
            
        } else {
            
            DispatchQueue.main.async { [ weak self ] in
                
                self?.designView.image = image
                
                self?.designView.filterName = nil
                
                self?.delegate?.showAllFilter(for: image)
                
                self?.delegate?.editImageMode()
            }
            
            designView.imageFileName = fileName
        }
        
    }

    // MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if error != nil {
            
            saveImageAlert.alpha = 1
            saveImageAlert.addOn(self.view)
   
        } else {
            
            saveSuccessLabel.setupLabel(on: self, with: "Saved to camera roll")
            
            self.navigationController?.navigationBar.alpha = 0.1
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           animations: {[weak self] in
                            
                            self?.saveSuccessLabel.alpha = 1
                            
            }, completion: { done in
                    
                if done {
                
                    UIView.animate(withDuration: 0.5,
                                       delay: 1.2,
                                       animations: {[weak self] in
                                        
                                        self?.saveSuccessLabel.alpha = 0
                                        
                    }, completion: { [weak self] done in
                        
                        if done {
                            
                            self?.navigationController?.navigationBar.alpha = 1

                        }
                        
                    })
                }

            })

        }
    }

    @IBAction func addBtnTapped(_ sender: Any) {
        
        if addElementView.isHidden == true {
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                
                self?.addButton.transform = CGAffineTransform.init(rotationAngle: -(CGFloat.pi*7/4))
                
            }, completion: {  [weak self] done in
                
                if done {
                    
                    self?.addElementView.isHidden = false
                    
                    self?.hintView.isHidden = false
                    
                }
                
            })
       
        } else {
            
            UIView.animate(withDuration: 0.3, animations: {
                [weak self] in
                
                self?.addButton.transform = CGAffineTransform.init(rotationAngle: 0)
                
                }, completion: {  [weak self] done in
                    
                    if done {
                        
                        self?.addElementView.isHidden = true
                        
                        self?.hintView.isHidden = false
                        
                    }
                    
            })

        }

        addShapeContainerView.isHidden = true
        
    }

    @IBAction func addImageBtnTapped(_ sender: Any) {

        addImageContainerView.isHidden = false

        addingNewImage = true
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
            
        case PHAuthorizationStatus.authorized:
            
            self.present(fusumaAlbum, animated: true, completion: nil)
            
        case PHAuthorizationStatus.notDetermined:
            
            PHPhotoLibrary.requestAuthorization({ [weak self, fusumaAlbum] status in
                
                if status == .authorized {
                    
                    DispatchQueue.main.async {
                        self?.present(fusumaAlbum, animated: true, completion: nil)
                    }
                }
                
            })
            
        default:
            
            showPhotoLibrayAlert()
        }

    }

    @IBAction func addTextBtnTapped(_ sender: Any) {

        addingTextMode()

    }
    
    @IBAction func addShapeBtnTapped(_ sender: Any) {
        
         addShapeContainerView.isHidden = false
         hintView.isHidden = true
         addElementView.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier
            == ALSegue.backgroundSegue.rawValue {
            
            guard let containerVC: BackgroundContainerViewController = segue
                .destination as? BackgroundContainerViewController
                else { return }
            
            containerVC.loadViewIfNeeded()
            containerVC.colorButton.isSelected = true
            containerVC.delegate = self
            
            self.delegate = containerVC
            
        } else if segue
            .identifier == ALSegue.shapeSegue.rawValue {
            
            guard let containerVC: ShapeContainerViewController = segue.destination as? ShapeContainerViewController
                else { return }
            
            containerVC.loadViewIfNeeded()
            containerVC.delegate = self
            
        }
    }

}

private extension DesignViewController {
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        switch viewModel.entry {
        case .new:
            break
        case let .editing(design):
            design.transformDesign(for: designView)
            designView.subviews.forEach {
                addAllGesture(to: $0)
            }
        }
    }
}
