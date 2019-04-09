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

struct NotificationInfo {
    
    static let newText = ""
    static let newImage = UIImage()
    static let addImage = UIImage()
    static let editedImage = [UIView]()
    static let addingMode = true
    
}

class ViewController: UIViewController, UITextViewDelegate, FusumaDelegate {

    @IBOutlet weak var designView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var hintLabel: UILabel!
    
    @IBOutlet weak var addImageContainerView: UIView!

    @IBOutlet weak var addButton: UIButton! {
        
        didSet {
            addButton.layer.cornerRadius = addButton.frame.width/2
            addButton.clipsToBounds = true
        }
    }
    @IBOutlet weak var textView: UITextView! 
    
    var editingView: UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        notEditingMode()
        scrollView.isHidden = true
        containerView.isHidden = true
        addImageContainerView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGesture(to: designView, action: #selector(designViewClicked(_:)))
        
        createNotification()
        
        setupNavigationBar()
    }

    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
           
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
            let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            print(paths)
        }
    }
    
    @IBAction func addLabelBtnTapped(_ sender: Any) {
        
        let txtLabel = UILabel(frame: CGRect(x: designView.frame.origin.x, y:designView.frame.origin.y, width: 200, height: 100))
        
        txtLabel.backgroundColor = UIColor.blue
        txtLabel.textAlignment = .center
        txtLabel.textColor = UIColor.red
    
        txtLabel.text = "I'm a new label"
        txtLabel.font.withSize(100)
        
        designView.addSubview(txtLabel)
        
        
        txtLabel.isUserInteractionEnabled = true

        addAllGesture(to: txtLabel)

    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        
        scrollView.isHidden = !scrollView.isHidden
    }
    
    @IBAction func downBtnTapped(_ sender: Any) {
        
        guard let editingView = editingView  else{ return }
        designView.sendSubviewToBack(editingView)
      
    }

    @IBAction func addImageBtnTapped(_ sender: Any) {
        
        addImageContainerView.isHidden = false
        containerView.isHidden = true
        
        scrollView.isHidden = !scrollView.isHidden
        
    }
    
    @IBAction func addTextBtnTapped(_ sender: Any) {
        
        addingTextMode()
        
    }
}

extension ViewController {
    
    func addGesture(to view: UIView, action: Selector) {
        
        let gesture = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(gesture)
        
    }
    
    @objc func designViewClicked(_ sender: UITapGestureRecognizer) {
 
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.availableModes = [FusumaMode.library, FusumaMode.camera] // Add .video capturing mode to the default .library and .camera modes
        fusuma.cropHeightRatio = 1 // Height-to-width ratio. The default value is 1, which means a squared-size photo.
        fusuma.allowMultipleSelection = false // You can select multiple photos from the camera roll. The default value is false.
        self.present(fusuma, animated: true, completion: nil)
        
    }
   
    //Notification for image picked
    func createNotification() {
        
        // 註冊addObserver
        let notificationName = Notification.Name(NotiName.changeBackgroundImage.rawValue)
        
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

    }
    
    // 收到通知後要執行的動作
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
            }
        }
    }
    
    @objc func addImage(noti: Notification) {
        
        guard let userInfo = noti.userInfo,
            let addImage = userInfo[NotificationInfo.addImage] as? UIImage else { return }
        
        let newImage = UIImageView(frame: CGRect(x: designView.center.x-100, y:designView.center.y-100, width: 200, height: 200))
        newImage.image = addImage
        
        designView.addSubview(newImage)
        
        goToEditingVC(with: newImage, navigationBarForImage: true)
   
    }
    
    @objc func updateImage(noti: Notification) {
        if let userInfo = noti.userInfo,
            let newImage = userInfo[NotificationInfo.editedImage] as? [UIView]{
          
            guard newImage.count != 0 else { return }
            
            for i in 0...newImage.count-1 {

                designView.addSubview(newImage[i])
                addAllGesture(to: newImage[i])
                
            }
        }
    }
}

//Handle Gesture
extension ViewController {
    
    func addAllGesture(to newView: UIView){
        
        newView.isUserInteractionEnabled = true
        
        //Handle label to tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        newView.addGestureRecognizer(tap)

    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        guard let tappedView = sender.view else { return }

        designView.bringSubviewToFront(tappedView)
        
        guard ((tappedView as? UIImageView) != nil) else {
            
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
            
            guard let transform = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale) else { return }
            
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
extension ViewController {
    
    func setupNavigationBar() {
        
        //Right Buttons
        let button1 = UIBarButtonItem(image: UIImage(named: ImageAsset.Icon_Share.rawValue), style: .plain, target: self, action: #selector(didTapShareButton(sender:)))
        
        let button2 = UIBarButtonItem(image: UIImage(named: ImageAsset.Icon_Download.rawValue), style: .plain, target: self, action: #selector(didTapDownloadButton(sender:)))
        
        self.navigationItem.rightBarButtonItems  = [button1, button2]
        
        //Left Buttons
        let leftButton = UIBarButtonItem(image: UIImage(named: ImageAsset.Icon_profile.rawValue), style: .plain, target: self, action: #selector(didTapProfileButton(sender:)))
         self.navigationItem.leftBarButtonItem  = leftButton
    }
    
    @objc func didTapProfileButton(sender: AnyObject) {
       print("profile btn tapped")
        
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
        
        UIImageWriteToSavedPhotosAlbum(imageWithLabel, self, #selector(image(_: didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @objc func didTapShareButton(sender: AnyObject) {
        
    }
}

extension ViewController {
    
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
        
        let newText = UITextView(frame: CGRect(x:textView.frame.origin.x-designView.frame.origin.x, y: textView.frame.origin.y-designView.frame.origin.y, width: textView.frame.width, height: textView.frame.height))
        
        newText.text = textView.text
        newText.font = textView.font
        newText.backgroundColor = UIColor.clear
        newText.textAlignment = textView.textAlignment
        
        newText.addDoneButtonOnKeyboard()
        
        addAllGesture(to: newText)
        
        designView.addSubview(newText)
        
        return newText
    }
    
    func goToEditingVC(with viewToBeEdit: UIView, navigationBarForImage: Bool) {
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: EditingViewController.self)) as? EditingViewController else { return }
        
        vc.loadViewIfNeeded()
        
        vc.designView.image = designView.image
        
        vc.editingView = viewToBeEdit
        
        let count = designView.subviews.count
        
        for _ in 0...count-1 {
            
            guard let subViewToAdd = designView.subviews.first else { return }
            
            vc.designView.addSubview(subViewToAdd)
        }
        
        switch navigationBarForImage {
        case true:
            vc.navigationBarForImage()
        default:
            vc.navigationBarForText()
           
        }

        show(vc, sender: nil)
    }

}

extension ViewController {
    
    
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        designView.image = image
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
    
}

