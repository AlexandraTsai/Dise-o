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

// swiftlint:disable file_length
class DesignViewController: UIViewController, UITextViewDelegate, FusumaDelegate {

    @IBOutlet weak var designView: ALDesignView!
    @IBOutlet weak var containerView: ContainerViewController!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var hintView: UIView!

    @IBOutlet weak var addImageContainerView: UIView!
    @IBOutlet weak var addShapeContainerView: UIView!
    
    @IBOutlet weak var addButton: UIButton! {

        didSet {
            addButton.layer.cornerRadius = addButton.frame.width/2
            addButton.clipsToBounds = true
        }
    }
    @IBOutlet weak var textView: UITextView!

    var editingView: UIView?
    var addingNewImage = false

    let fusuma = FusumaViewController()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        notEditingMode()

        addImageContainerView.isHidden = true
        addShapeContainerView.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addGesture(to: designView, action: #selector(designViewClicked(_:)))

        createNotification()

        setupNavigationBar()

        setupImagePicker()
        
        scrollView.isHidden = true
    }

    // MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let alert = UIAlertController(title: "Save error",
                                       message: error.localizedDescription,
                                       preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            
        } else {
            let alert = UIAlertController(title: "Saved!",
                                       message: "Your altered image has been saved to your photos.",
                                       preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)

        }
    }

    @IBAction func addBtnTapped(_ sender: Any) {

        scrollView.isHidden = !scrollView.isHidden
        
        addShapeContainerView.isHidden = true
        
        hintView.isHidden = false

    }

//    @IBAction func downBtnTapped(_ sender: Any) {
//
//        guard let editingView = editingView  else { return }
//        designView.sendSubviewToBack(editingView)
//
//    }

    @IBAction func addImageBtnTapped(_ sender: Any) {

        addImageContainerView.isHidden = false

        addingNewImage = true
        self.present(fusuma, animated: true, completion: nil)

    }

    @IBAction func addTextBtnTapped(_ sender: Any) {

        addingTextMode()

    }
    
    @IBAction func addShapeBtnTapped(_ sender: Any) {
        
         addShapeContainerView.isHidden = false
         hintView.isHidden = true
         scrollView.isHidden = true
    }
}

extension DesignViewController {

    func addGesture(to view: UIView, action: Selector) {

        let gesture = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(gesture)

    }

    @objc func designViewClicked(_ sender: UITapGestureRecognizer) {

        scrollView.isHidden = true
        hintView.isHidden = true

        let notificationName = Notification.Name(NotiName.changeBackground.rawValue)

        if designView.image == nil {

            //只顯示 Camera Roll, Colors(Default)
            NotificationCenter.default.post(name: notificationName,
                                            object: nil,
                                            userInfo: [NotificationInfo.backgroundIsImage: false])
            addShapeContainerView.isHidden = true

        } else {

            //只顯示 Camera Roll, Filter(Default), Colors
            NotificationCenter.default.post(
                name: notificationName,
                object: nil,
                userInfo: [NotificationInfo.backgroundIsImage: true])
            addShapeContainerView.isHidden = true
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier
            == "backgroundSegue" {

            guard let containerVC: ContainerViewController = segue.destination as? ContainerViewController
                else { return }
            
            containerVC.loadViewIfNeeded()
            containerVC.colorButton.isSelected = true
        } else if segue.identifier
            == "shapeSegue" {
            
            guard let containerVC: ShapeContainerViewController = segue.destination as? ShapeContainerViewController
                else { return }
            
            containerVC.loadViewIfNeeded()
            
        }
    }

    //Notification for image picked
    func createNotification() {

        // 註冊addObserver
        let notificationName = Notification.Name(NotiName.changeBackground.rawValue)

        NotificationCenter.default.addObserver(self, selector:
            #selector(changeImage(noti:)), name: notificationName, object: nil)

        let notificationName2 = Notification.Name(NotiName.addImage.rawValue)

        NotificationCenter.default.addObserver(self, selector:
            #selector(addImage(noti:)), name: notificationName2, object: nil)

        let notificationName3 = Notification.Name(NotiName.updateImage.rawValue)

        NotificationCenter.default.addObserver(self, selector:
            #selector(updateImage(noti:)), name: notificationName3, object: nil)

        let notificationName4 = Notification.Name(NotiName.addingMode.rawValue)

        NotificationCenter.default.addObserver(self, selector:
            #selector(switchToAddingMode(noti:)), name: notificationName4, object: nil)

        let notificationName5 = Notification.Name(NotiName.pickingPhotoMode.rawValue)

        NotificationCenter.default.addObserver(self, selector:
            #selector(showPickPhotoVC(noti:)), name: notificationName5, object: nil)

        let notificationName6 = Notification.Name(NotiName.addShape.rawValue)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(addShape(noti:)), name: notificationName6, object: nil)
        
        let notificationName7 = Notification.Name(NotiName.backgroundColor.rawValue)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeBackgroundColor(noti:)), name: notificationName7, object: nil)

    }

    // 收到通知後要執行的動作
    @objc func showPickPhotoVC(noti: Notification) {
        if let userInfo = noti.userInfo,
            let mode = userInfo[NotificationInfo.pickingPhotoMode] as? Bool {
            if mode == true {
                self.present(fusuma, animated: true, completion: nil)
            }
        }
    }

    @objc func changeImage(noti: Notification) {
        if let userInfo = noti.userInfo,
            let newImage = userInfo[NotificationInfo.newImage] as? UIImage {
            designView.image = newImage
        }
    }
    @objc func switchToAddingMode(noti: Notification) {
        if let userInfo = noti.userInfo,
            let mode = userInfo[NotificationInfo.addingMode] as? Bool {
            if mode == true {
                scrollView.isHidden = false
            } else {
                 scrollView.isHidden = true
            }
        }
    }

    @objc func addImage(noti: Notification) {

        guard let userInfo = noti.userInfo,
            let addImage = userInfo[NotificationInfo.addImage] as? UIImage
            else { return }

        let newImage = ALImageView(frame: CGRect(x: designView.center.x-100,
                                                 y: designView.center.y-100,
                                                 width: 200,
                                                 height: 200))
        newImage.image = addImage

        designView.addSubview(newImage)

        goToEditingVC(with: newImage, navigationBarForImage: true)

    }

    @objc func updateImage(noti: Notification) {
        if let userInfo = noti.userInfo,
            let newImage = userInfo[NotificationInfo.editedImage] as? [UIView] {

            guard newImage.count != 0 else { return }

            for count in 0...newImage.count-1 {

                designView.addSubview(newImage[count])
                addAllGesture(to: newImage[count])

            }
        }
    }
    
    @objc func addShape(noti: Notification) {
        
        guard let userInfo = noti.userInfo,
            let shapeType = userInfo[NotificationInfo.addShape] as? String
            else { return }
        
        let newShape = ShapeView(frame: CGRect(x: designView.frame.width/2-75,
                                               y: designView.frame.height/2-75,
                                               width: 150,
                                               height: 150))
        
        newShape.shapeType = shapeType
        
        for shape in ShapeAsset.allCases where shape.rawValue == shapeType {
                
            let border = shape.shapeBorderOnly()
                
            if border {
                    
                newShape.stroke =  true
                    
            } else {
                    
                if designView.image == nil && designView.backgroundColor == UIColor.white {
                        
                    newShape.shapeColor = UIColor.init(red: 221/255, green: 221/255, blue: 221/255, alpha: 1)
                }
            }
        }
        
        designView.addSubview(newShape)
        addAllGesture(to: newShape)
     
        goToEditingVC(with: newShape, navigationBarForImage: false)
        
    }
    
    @objc func changeBackgroundColor(noti: Notification) {
        
        if let userInfo = noti.userInfo,
            let color = userInfo[NotificationInfo.backgroundColor] as? UIColor {
            
            designView.image = nil
            designView.backgroundColor = color
        }
    }
    
}

//Handle Gesture
extension DesignViewController {

    func addAllGesture(to newView: UIView) {

        newView.isUserInteractionEnabled = true

        //Handle label to tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        newView.addGestureRecognizer(tap)

    }

    @objc func handleTap(sender: UITapGestureRecognizer) {

        guard let tappedView = sender.view else { return }

        guard (tappedView as? ALImageView) != nil else {

            goToEditingVC(with: tappedView, navigationBarForImage: false)
            return
        }

        goToEditingVC(with: tappedView, navigationBarForImage: true)

    }

    @objc func handleRotation(sender: UIRotationGestureRecognizer) {

        guard  sender.view != nil else {
            return

        }

        if sender.state == .began || sender.state == .changed {

            guard let rotateValue = sender.view?.transform.rotated(by: sender.rotation) else {
                return
            }

            sender.view?.transform = rotateValue
            sender.rotation = 0

        }
    }

    @objc func handlePinch(sender: UIPinchGestureRecognizer) {

        guard  sender.view != nil else {
            return

        }

        if sender.state == .began || sender.state == .changed {

            guard let transform = sender.view?.transform.scaledBy(x: sender.scale*0/5,
                                                                  y: sender.scale*0/5) else { return }

            sender.view?.transform = transform
            sender.scale = 1.0

        }
    }

    @objc func handleDragged( _ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        let view = gesture.view

        guard let xCenter = view?.center.x, let yCenter = view?.center.y else { return }

        view?.center = CGPoint(x: xCenter+translation.x, y: yCenter+translation.y)
        gesture.setTranslation(CGPoint.zero, in: view)

    }

}

//Setup Navigation Bar
extension DesignViewController {

    func setupNavigationBar() {

        //Right Buttons
        let button1 = UIBarButtonItem(
            image: UIImage(named: ImageAsset.Icon_Share.rawValue),
            style: .plain,
            target: self,
            action: #selector(didTapShareButton(sender:)))

        let button2 = UIBarButtonItem(
            image: UIImage(named: ImageAsset.Icon_Download.rawValue),
            style: .plain,
            target: self,
            action: #selector(didTapDownloadButton(sender:)))

        self.navigationItem.rightBarButtonItems  = [button1, button2]

        //Left Buttons
        let leftButton = UIBarButtonItem(
            image: UIImage(named: ImageAsset.Icon_profile.rawValue),
            style: .plain,
            target: self,
            action: #selector(didTapProfileButton(sender:)))
         self.navigationItem.leftBarButtonItem  = leftButton
    }

    @objc func didTapProfileButton(sender: AnyObject) {
        
        if designView.subviews.count > 0 {
            
             addSubImage()
        }
        
       if designView.createTime == nil {
        
            designView.createTime = Int64(Date().timeIntervalSince1970)
        
            guard let createTime = designView.createTime else { return }
        
            StorageManager.shared.saveDesign(
                newDesign: designView,
                createTime: createTime,
                designName: designView.designName,
                frame: designView.frame,
                backgroundColor: designView.backgroundColor,
                backgroundImage: designView.image,
                completion: { result in
                    switch result {
                    case .success(_):
                    
                        print("Save success.")
                    
                    case .failure(_):
                    
                        print("Fail to save")
                }
            })
        
        } else {
        
            guard let createTime = designView.createTime else { return }
        
            StorageManager.shared.updateDesign(
                design: designView,
                createTime: createTime,
                completion: { result in
                
                    switch result {
                    
                    case .success(_):
                    
                        print("Save success.")
                    
                    case .failure(_):
                    
                        print("Fail to save")
                    }
                })
        }
        
        self.navigationController?.popViewController(animated: true)
    }

    @objc func didTapDownloadButton(sender: AnyObject) {

        UIGraphicsBeginImageContextWithOptions(designView.bounds.size, false, 0)

        guard let currentContent = UIGraphicsGetCurrentContext() else {
            return
        }
        designView.layer.render(in: currentContent)

        // here is final image
        guard let imageWithLabel = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }

        UIGraphicsEndImageContext()

        UIImageWriteToSavedPhotosAlbum(imageWithLabel,
                                       self,
                                       #selector(image(_: didFinishSavingWithError:contextInfo:)),
                                       nil)

    }

    @objc func didTapShareButton(sender: AnyObject) {

    }
}

extension DesignViewController {

    //NavigationBar
    func addingTextMode() {

        navigationController?.navigationBar.isHidden = true
        textView.isHidden = false
        textView.becomeFirstResponder()

        textView.text = "Enter your text"

        textView.delegate = self

        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.endOfDocument)
    }

    func notEditingMode() {

        navigationController?.navigationBar.isHidden = false
        textView.isHidden = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {

        let newText = addTextView()

        notEditingMode()

        goToEditingVC(with: newText, navigationBarForImage: false)

    }

    func addTextView() -> UITextView {

        let contentSize = self.textView.sizeThatFits(self.textView.bounds.size)
        
        let newText = UITextView(
            frame: CGRect(x: textView.frame.origin.x-designView.frame.origin.x,
                          y: textView.frame.origin.y-designView.frame.origin.y,
                          width: textView.frame.width,
                          height: contentSize.height))
        
        newText.text = textView.text
        newText.font = textView.font
        newText.backgroundColor = UIColor.clear
        newText.textAlignment = textView.textAlignment
        newText.textColor = UIColor.black
        newText.isScrollEnabled = false
       
        newText.addDoneButtonOnKeyboard()

        addAllGesture(to: newText)

        designView.addSubview(newText)

        return newText
    }

    func goToEditingVC(with viewToBeEdit: UIView, navigationBarForImage: Bool) {

        guard let editingVC = UIStoryboard(
            name: "Main",
            bundle: nil).instantiateViewController(
                withIdentifier: String(describing: EditingViewController.self)) as? EditingViewController
            else { return }

        editingVC.loadViewIfNeeded()

        editingVC.designView.backgroundColor = designView.backgroundColor
        editingVC.designView.image = designView.image

        let count = designView.subviews.count

        for _ in 0...count-1 {

            guard let subViewToAdd = designView.subviews.first else { return }

            editingVC.designView.addSubview(subViewToAdd)
        }

        switch navigationBarForImage {
        case true:
            editingVC.complexNavigationBar()
        default:
            editingVC.normalNavigationBar()

        }

        editingVC.editingView = viewToBeEdit
        
        show(editingVC, sender: nil)
    }

}

extension DesignViewController {

    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        if addingNewImage == true {
 
            let newImage = ALImageView(frame: CGRect(x: designView.frame.width/2-75,
                                                     y: designView.frame.height/2-75,
                                                     width: 150,
                                                     height: 150))
            newImage.image = image

            designView.addSubview(newImage)
            
            goToEditingVC(with: newImage, navigationBarForImage: true)
            
            addingNewImage = false
            
        } else {
            designView.image = image
            
            let notificationName = Notification.Name(NotiName.changeBackground.rawValue)
            
            NotificationCenter.default.post(name: notificationName,
                                            object: nil,
                                            userInfo: [NotificationInfo.backgroundIsImage: true])
        }
    
    }

    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage, source: FusumaMode) {

        print("Called just after FusumaViewController is dismissed.")
    }

    func fusumaVideoCompleted(withFileURL fileURL: URL) {

        print("Called just after a video has been selected.")
    }

    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {

        print("Camera roll unauthorized")
    }

    // Return selected images when you allow to select multiple photos.
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {

        print("Multiple images are selected.")
    }

    // Return an image and the detailed information.
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {

    }

    func setupImagePicker() {

        fusuma.delegate = self
        fusuma.availableModes = [FusumaMode.library, FusumaMode.camera]
        // Add .video capturing mode to the default .library and .camera modes
        fusuma.cropHeightRatio = 1
        // Height-to-width ratio. The default value is 1, which means a squared-size photo.
        fusuma.allowMultipleSelection = false
        // You can select multiple photos from the camera roll. The default value is false.

        fusumaSavesImage = true

        fusumaTitleFont = UIFont(name: FontName.copperplate.boldStyle(), size: 18)

        fusumaBackgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)

        fusumaCameraRollTitle = "Camera Roll"

        fusumaTintColor = UIColor(red: 244/255, green: 200/255, blue: 88/255, alpha: 1)

        fusumaCameraTitle = "Camera"
        fusumaBaseTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }

}

extension DesignViewController {
    
    func addSubImage() {
        
        let count = designView.subviews.count
        
        for index in 0...count-1 {
            
            let subViewToAdd = designView.subviews[index]
            
            let imageView = subViewToAdd as? ALImageView
            
            guard let view = imageView else { return }
            
            view.index = index
            
            designView.subImages.append(view)
            
        }
    }
    
}
// swiftlint:enable file_length
