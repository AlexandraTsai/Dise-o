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

struct NotificationInfo {
    
    static let newText = ""
    static let newImage = UIImage()
    static let addImage = UIImage()
    static let editedImage = [UIView]()
    
}

class ViewController: UIViewController {

    @IBOutlet weak var designView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var addImageContainerView: UIView!
    @IBOutlet weak var textField: UITextField!
    
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
        
        //Handle label to tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        txtLabel.addGestureRecognizer(tap)
      
        //Enable label to rotate
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(sender:)))
        txtLabel.addGestureRecognizer(rotate)
        
         //Enable to move label
        let move = UIPanGestureRecognizer(target: self, action: #selector(handleDragged(_ :)))
        txtLabel.addGestureRecognizer(move)
        
         //Enable to pinch/change size of label
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
        txtLabel.addGestureRecognizer(pinch)
    }

    @IBAction func addImageButtonTapped(_ sender: Any) {
        
        let newImage = UIImageView(frame: CGRect(x: designView.center.x-100, y:designView.center.y-100, width: 200, height: 200))
        newImage.image = UIImage(named: "IMG_4670")
        
        designView.addSubview(newImage)
        
        newImage.isUserInteractionEnabled = true
        
        //Handle label to tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        newImage.addGestureRecognizer(tap)
        
        //Enable label to rotate
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(sender:)))
        newImage.addGestureRecognizer(rotate)
        
        //Enable to move label
        let move = UIPanGestureRecognizer(target: self, action: #selector(handleDragged(_ :)))
        newImage.addGestureRecognizer(move)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
        newImage.addGestureRecognizer(pinch)
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        
        scrollView.isHidden = !scrollView.isHidden
    }
    
    @IBAction func downBtnTapped(_ sender: Any) {
        
//        guard let subView = designView.subviews.last else { return }
//        designView.sendSubviewToBack(subView)
        
        guard let subView = editingView, let editingView = editingView  else{ return }
        designView.sendSubviewToBack(editingView)
      
    }
    
    @IBAction func upBtnTapped(_ sender: Any) {
        
//        guard let subView = designView.subviews.first else { return }
//        designView.bringSubviewToFront(subView)
        
        guard let subView = editingView, let editingView = editingView  else{ return }
        designView.bringSubviewToFront(editingView)
      
    }
    @IBAction func addImageBtnTapped(_ sender: Any) {
        
        addImageContainerView.isHidden = false
        containerView.isHidden = true
        
        scrollView.isHidden = !scrollView.isHidden
        
    }
    
    @IBAction func addTextBtnTapped(_ sender: Any) {
        
        addTextMode()
        
    }
}

extension ViewController {
    
    func addGesture(to view: UIView, action: Selector) {
        
        let gesture = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(gesture)
        
    }
    
    @objc func designViewClicked(_ sender: UITapGestureRecognizer) {
       
        if designView.image == nil {
            containerView.isHidden = false
            scrollView.isHidden = true
        } else {
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageEditViewController") as? ImageEditViewController else { return }
            self.show(vc, sender: nil)
        }
        
    }
  
    //Notification for image picked
    func createNotification() {
        
        // 註冊addObserver
        let notificationName = Notification.Name("changeImage")
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeImage(noti:)), name: notificationName, object: nil)
        
        let notificationName2 = Notification.Name("addImage")
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(addImage(noti:)), name: notificationName2, object: nil)
        
        let notificationName3 = Notification.Name("updateImage")
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(updateImage(noti:)), name: notificationName3, object: nil)

    }
    
    // 收到通知後要執行的動作
    @objc func changeImage(noti: Notification) {
        if let userInfo = noti.userInfo,
            let newImage = userInfo[NotificationInfo.newImage] as? UIImage {
            designView.image = newImage
        }
    }
    
    @objc func addImage(noti: Notification) {
        
        guard let userInfo = noti.userInfo,
            let addImage = userInfo[NotificationInfo.addImage] as? UIImage else { return }
        
        let newImage = UIImageView(frame: CGRect(x: designView.center.x-100, y:designView.center.y-100, width: 200, height: 200))
        newImage.image = addImage
        
        designView.addSubview(newImage)
        
        newImage.isUserInteractionEnabled = true
        
        addAllGesture(to: newImage)
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageEditViewController") as? ImageEditViewController else { return }
        
        vc.loadViewIfNeeded()
        
        vc.designView.image = designView.image
        let count = designView.subviews.count
        
        for _ in 0...count-1 {
            
            vc.designView.addSubview(designView.subviews.first!)
        }
     
        show(vc, sender: nil)
    }
    
    @objc func updateImage(noti: Notification) {
        if let userInfo = noti.userInfo,
            let newImage = userInfo[NotificationInfo.editedImage] as? [UIView]{
            
            print("##################")
            print(newImage.count)
            print(newImage)
            
            for _ in 0...newImage.count-1 {
                
                guard let updateImage = newImage.first else { return }
            
                print(newImage.count)
                designView.addSubview(newImage.first!)
                designView.addSubview(newImage.last!)
            }
             print(newImage.count)
            print(designView.subviews)
        }
    }
  
}

//Handle Gesture
extension ViewController {
    
    func addAllGesture(to newView: UIView){
        
        //Handle label to tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        newView.addGestureRecognizer(tap)
        
        //Enable label to rotate
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(sender:)))
        newView.addGestureRecognizer(rotate)
        
        //Enable to move label
        let move = UIPanGestureRecognizer(target: self, action: #selector(handleDragged(_ :)))
        newView.addGestureRecognizer(move)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
        newView.addGestureRecognizer(pinch)
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        guard  sender.view != nil else {
            return
            
        }
        
        editingView = sender.view
        editingView?.layer.borderColor = UIColor.white.cgColor
        editingView?.layer.borderWidth = 1
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
    
    func addTextMode() {
        navigationController?.navigationBar.isHidden = true
        textField.isHidden = false
        textField.becomeFirstResponder()
        
    }
    
    func notEditingMode() {
        navigationController?.navigationBar.isHidden = false
        textField.isHidden = true
    }
}
