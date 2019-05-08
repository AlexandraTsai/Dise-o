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
class DesignViewController: BaseViewController, UITextViewDelegate {

    @IBOutlet weak var designView: ALDesignView! {
        
        didSet {
            
            guard let fileName = designView.imageFileName else { return }
            
            guard let image = loadImageFromDiskWith(fileName: fileName) else { return }
            
            delegate?.showAllFilter(for: image)
            
        }
        
    }
    
    @IBOutlet weak var shadowView: UIView! {
        
        didSet {
                
            shadowView.clipsToBounds = false
            shadowView.layer.shadowColor = UIColor.DSColor.mediumGray.cgColor
            shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
            shadowView.layer.shadowRadius = 10
            shadowView.layer.shadowOpacity = 0.6
            
        }
        
    }
    
    @IBOutlet weak var containerView: BackgroundContainerViewController!
    
    @IBOutlet weak var scrollView: UIScrollView!
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
    
    weak var delegate: BaseViewControllerProtocol?

    var editingView: UIView?
    var addingNewImage = false
    var showFilter = true
  
    let saveImageAlert = GoSettingAlertView()
  
    let saveSuccessLabel = SaveSuccessLabel()
    
    let openLibraryAlert = GoSettingAlertView()

    let openCameraAlert = GoSettingAlertView()
    
    deinit {
        print("DesignViewController deinit \(self)")
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
     
        notEditingMode()

        addImageContainerView.isHidden = true
        addShapeContainerView.isHidden = true
        
        scrollView.isHidden = true
        addButton.transform = CGAffineTransform(rotationAngle: 0)
        
        self.tabBarController?.tabBar.barTintColor = UIColor.clear
        
        if designView.image == nil {
            
            self.delegate?.noImageMode()
            
        } else {
            
            guard let fileName = designView.imageFileName else { return }
            
            guard let image = loadImageFromDiskWith(fileName: fileName) else { return }
            
            self.delegate?.showAllFilter(for: image)
            
            if showFilter {
                self.delegate?.editImageMode()
            } else {
                self.delegate?.pickImageMode()
            }
        }
     
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addGesture(to: designView, action: #selector(designViewClicked(_:)))

        createNotification()

        setupNavigationBar()

        scrollView.isHidden = true

        self.view.addSubview(saveSuccessLabel)
        self.view.addSubview(openLibraryAlert)
        self.view.addSubview(openCameraAlert)
        saveSuccessLabel.alpha = 0
        openLibraryAlert.alpha = 0
        openCameraAlert.alpha = 0
        
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
                                        
                    }, completion: nil)
                }

            })

        }
    }

    @IBAction func addBtnTapped(_ sender: Any) {
        
        if scrollView.isHidden == true {
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                
                self?.addButton.transform = CGAffineTransform.init(rotationAngle: -(CGFloat.pi*7/4))
                
            }, completion: {  [weak self] done in
                
                if done {
                    
                    self?.scrollView.isHidden = false
                    
                    self?.hintView.isHidden = false
                    
                }
                
            })
       
        } else {
            
            UIView.animate(withDuration: 0.3, animations: {
                [weak self] in
                
                self?.addButton.transform = CGAffineTransform.init(rotationAngle: 0)
                
                }, completion: {  [weak self] done in
                    
                    if done {
                        
                        self?.scrollView.isHidden = true
                        
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
         scrollView.isHidden = true
    }
}

extension DesignViewController {

    func addGesture(to view: UIView, action: Selector) {

        let gesture = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(gesture)

    }
    
    @objc func endEditing(_ sender: UITapGestureRecognizer) {
        
        hintView.isHidden = false
        scrollView.isHidden = true
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            
            self?.addButton.transform = CGAffineTransform.init(rotationAngle: 0)
            
        }
        
    }

    @objc func designViewClicked(_ sender: UITapGestureRecognizer) {
      
        scrollView.isHidden = true
        hintView.isHidden = !hintView.isHidden
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            
            self?.addButton.transform = CGAffineTransform(rotationAngle: 0)
        }
        
        if designView.image == nil {

            addShapeContainerView.isHidden = true
            
            delegate?.noImageMode()

        } else {
           
            delegate?.editImageMode()

        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier
            == "backgroundSegue" {

            guard let containerVC: BackgroundContainerViewController = segue.destination as? BackgroundContainerViewController
                else { return }
            
            containerVC.loadViewIfNeeded()
            containerVC.colorButton.isSelected = true
            containerVC.delegate = self
            
            self.delegate = containerVC
            
        } else if segue
            .identifier == "shapeSegue" {
            
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

        let notificationName6 = Notification.Name(NotiName.takePhotoMode.rawValue)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(showCameraVC(noti:)), name: notificationName6, object: nil)
        
        let notificationName7 = Notification.Name(NotiName.addShape.rawValue)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(addShape(noti:)), name: notificationName7, object: nil)
        
    }

    // 收到通知後要執行的動作
    @objc func showPickPhotoVC(noti: Notification) {
        if let userInfo = noti.userInfo,
            let mode = userInfo[NotificationInfo.pickingPhotoMode] as? Bool {
            if mode == true {
                
                DispatchQueue.main.async { [weak self, fusumaAlbum] in
                    
                    self?.present(fusumaAlbum, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    @objc func showCameraVC(noti: Notification) {
        if let userInfo = noti.userInfo,
            let mode = userInfo[NotificationInfo.takePhotoMode] as? Bool {
            if mode == true {
                
                DispatchQueue.main.async { [weak self, fusumaCamera] in
                    
                    self?.present(fusumaCamera, animated: true, completion: nil)
                }
                
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
               
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    
                    self?.addButton.transform = CGAffineTransform.init(rotationAngle: -(CGFloat.pi*7/4))
                    
                    }, completion: {  [weak self] done in
                        
                        if done {
                            
                            self?.scrollView.isHidden = false
                            
                            self?.hintView.isHidden = false
                            
                        }
                        
                })
               
            } else {
                
                scrollView.isHidden = true
                
                hintView.isHidden = false
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
                
                if let imageView = newImage[count] as? ALImageView {
                    
                    print(imageView.filterName)
                    
                }

                designView.addSubview(newImage[count])
                addAllGesture(to: newImage[count])

            }
        }
    }
    
    @objc func addShape(noti: Notification) {
        
        guard let userInfo = noti.userInfo,
            let shapeType = userInfo[NotificationInfo.addShape] as? String
            else { return }
        
        let newShape = ALShapeView(frame: CGRect(x: designView.frame.width/2-75,
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
    
    func changeColor(to color: UIColor) {
        
        designView.image = nil
        designView.backgroundColor = color
        
        delegate?.noImageMode()
        
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
            image: UIImage(named: ImageAsset.Icon_HomePage.rawValue),
            style: .plain,
            target: self,
            action: #selector(tapHomeBtn(sender:)))
         self.navigationItem.leftBarButtonItem  = leftButton
        
    }
   
    // swiftlint:disable cyclomatic_complexity
    @objc func tapHomeBtn(sender: AnyObject) {
        
        let date = String(Date().timeIntervalSince1970)
        
        let fileName = "Screenshot_\(date)"
        
        let screenshot = designView.takeScreenshot()
        
        designView.screenshotName = fileName
        
        saveImage(fileName: fileName, image: screenshot)
        
        if designView.subviews.count > 0 {
            
             prepareForSaving()
        }
        
       if designView.createTime == nil {
        
            designView.createTime = Int64(Date().timeIntervalSince1970)
        
            guard let createTime = designView.createTime else { return }
        
            StorageManager.shared.saveDesign(
                newDesign: designView,
                createTime: createTime,
                completion: { result in
                    
                    switch result {
                    case .success:
                    
                        print("Save success.")
                    
                    case .failure:
                    
                        print("Fail to save")
                }
            })
        
        } else {
        
            guard let createTime = designView.createTime else { return }
        
            if designView.image == nil {
            
                designView.imageFileName = nil
            }
        
            StorageManager.shared.updateDesign(
                design: designView,
                createTime: createTime,
                completion: { result in
                
                    switch result {
                    
                    case .success:
                    
                        StorageManager.shared.deleteSubElement(completion: { result in
                            
                            switch result {
                                
                            case .success:
                                
                                print("Success to delete unused data")
                                
                            case .failure:
                                
                                print("Fail to delete unused data")
                            }
                        })
                    
                    case .failure:
                    
                        print("Fail to save")
                    }
                })
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    // swiftlint:enable cyclomatic_complexity
    
    @objc func didTapShareButton(sender: AnyObject) {
        
        let screenshot = designView.takeScreenshot()
        
        let imageToShare = [ screenshot ]
        
        let activityController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        
        activityController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityController, animated: true, completion: nil)
        
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
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
            
        case PHAuthorizationStatus.authorized, PHAuthorizationStatus.notDetermined:
            
            UIImageWriteToSavedPhotosAlbum(imageWithLabel,
                                           self,
                                           #selector(image(_: didFinishSavingWithError:contextInfo:)),
                                           nil)
            
        default:
            
            saveImageAlert.alpha = 1
            saveImageAlert.addOn(self.view)
            
        }

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

    func addTextView() -> ALTextView {

        let contentSize = self.textView.sizeThatFits(self.textView.bounds.size)
        
        let newText = ALTextView(
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

        editingVC.setupNavigationBar()
        
        if let imageView = viewToBeEdit as? ALImageView {
            
            if let image = imageView.originImage {
                
                editingVC.delegate?.showAllFilter(for: image)
                editingVC.delegate?.editImageMode()
                
            }
          
        }

        editingVC.editingView = viewToBeEdit
        
        show(editingVC, sender: nil)
    }

}

extension DesignViewController {
    
    func prepareForSaving() {
        
        let count = designView.subviews.count
        
        for index in 0..<count {
            
            let subViewToAdd = designView.subviews[index]
            
            if let imageView = subViewToAdd as? ALImageView {
                
            imageView.index = index
          
            designView.subImages.append(imageView)
            
            } else if let textView = subViewToAdd as? ALTextView {
                
                textView.index = index
                
                designView.subTexts.append(textView)
                
            } else if let shapeView = subViewToAdd as? ALShapeView {
                
                shapeView.index = index
                
                designView.subShapes.append(shapeView)
            }
        }
    }
    
}

extension DesignViewController: BaseContainerViewControllerProtocol {
    
    func showPhotoLibrayAlert() {
        
        openLibraryAlert.alpha = 1
        openLibraryAlert.addOn(self.view)
        openLibraryAlert.titleLabel.text = "To use your own photos, please allow access to your camera roll."
    }
    
    func showCameraAlert() {
        
        openCameraAlert.alpha = 1
        openCameraAlert.addOn(self.view)
        openCameraAlert.titleLabel.text = "To use the Camera, pleace allow permission for Diseño in Settings."
        
    }
    
    func changeImageWith(filter: FilterType?) {
        
        guard let fileName = designView.imageFileName else { return }
        
        let originImage = loadImageFromDiskWith(fileName: fileName)
 
        if let filter = filter {
            
            DispatchQueue.main.async { [weak self] in
                
                self?.designView.image = originImage?.addFilter(filter: filter)
                
            }
            
            designView.filterName = filter
            
        } else {
            
            DispatchQueue.main.async { [weak self] in
                
                 self?.designView.image = originImage
            }
           
            designView.filterName = nil
        }
       
    }
}
// swiftlint:enable file_length
