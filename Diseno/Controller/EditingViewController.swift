//
//  ImageEditViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/1.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit
import Fusuma
import CoreGraphics

protocol EditingVCDelegate: AnyObject {
    
    func finishEdit(with subViews: [UIView])
}

class EditingViewController: BaseViewController, UITextViewDelegate {
    
    weak var finishEditDelegate: EditingVCDelegate?
    
    let openLibraryAlert = GoSettingAlertView()
    let openCameraAlert = GoSettingAlertView()
    
    var textContainerVC: TextContainerViewController?
    var imageContainerVC: ImageEditContainerViewController?
    
    var helperView = HelperView()
    
    var oldLocation: CGPoint?
    
    var newLocation: CGPoint?
    
    var originLocation = CGPoint(x: 0, y: 0)
    
    var originSize = CGSize(width: 0, height: 0)
    
    var tableViewIndex: Int = 0
    
    var editingView: UIView? {
        
        didSet {
            
            guard let editingView = editingView else {
                return
            }
            
            disableNavigationButton()
            
            createEditingHelper(for: editingView)
            
            changeEditingMode()
            
        }
    }
    
    @IBOutlet weak var imageEditContainerView: UIView!
    @IBOutlet weak var textEditContainterView: UIView!
    
    @IBOutlet weak var designView: ALDesignView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAlert()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        addGestureToAllSubview()
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == ALSegue.textSegue.rawValue {
            
            textContainerVC = segue.destination as? TextContainerViewController
            
            textContainerVC?.delegate = self
            
        } else if segue.identifier == ALSegue.imageSegue.rawValue {
            
            imageContainerVC = segue.destination as? ImageEditContainerViewController
            
            imageContainerVC?.delegate = self
            imageContainerVC?.editingDelegate = self
            self.delegate = imageContainerVC
           
        }
    }
    
    override func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        guard let imageView = editingView as? ALImageView else {
            return
        }
        
        let fileName = String(Date().timeIntervalSince1970)
        
        saveImage(fileName: fileName, image: image)
        
        imageView.imageFileName = fileName
        imageView.originImage = image
        imageView.image = image
        
        self.delegate?.showAllFilter(for: image)
        self.delegate?.editImageMode()
    }

}

//Setup Navigation Bar & Alert
extension EditingViewController {
    
    func setupAlert() {
        
        self.view.addSubview(openLibraryAlert)
        self.view.addSubview(openCameraAlert)
        
        openLibraryAlert.alpha = 0
        openCameraAlert.alpha = 0
        
    }

    func setupNavigationBar() {

        let button1 = UIBarButtonItem(
            image: UIImage(named: ImageAsset.Icon_TrashCan.rawValue),
            style: .plain,
            target: self,
            action: #selector(didTapDeleteButton(sender:)))

        let button2 = UIBarButtonItem(
            image: UIImage(named: ImageAsset.Icon_down.rawValue),
            style: .plain,
            target: self,
            action: #selector(didTapDownButton(sender:)))

        let button3 = UIBarButtonItem(
            image: UIImage(named: ImageAsset.Icon_up.rawValue),
            style: .plain,
            target: self,
            action: #selector(didTapUpButton(sender:)))

        let button4 = UIBarButtonItem(
            image: UIImage(named: ImageAsset.Icon_Copy.rawValue),
            style: .plain,
            target: self,
            action: #selector(didTapCopyButton(sender:)))

        self.navigationItem.rightBarButtonItems  = [button1, button2, button3, button4]

        //Left Buttons
        let leftButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(didTapDoneButton(sender:)))
        
        guard let font = UIFont(name: FontName.futura.rawValue,
                                size: 17.0) else { return }
        
        leftButton.setTitleTextAttributes([
            NSAttributedString.Key.font: font], for: .normal)
        
        self.navigationItem.leftBarButtonItem  = leftButton
    }

    func disableNavigationButton() {
        
        guard let editingView = editingView else { return }
        
        guard let index = designView.subviews.firstIndex(of: editingView) else { return }
        
        setupNavigationBar()
        
        switch index {
            
        //Editing view is the last one
        case 0:
            
            self.navigationItem.rightBarButtonItems?[1].isEnabled = false
        
        //Editing view is the first one
        case designView.subviews.count-1:
          
            self.navigationItem.rightBarButtonItems?[2].isEnabled = false
        
        default: break
        }
    }

    @objc func didTapDoneButton(sender: AnyObject) {
        
        helperView.removeFromSuperview()
        
        finishEditDelegate?.finishEdit(with: designView.subviews)
 
        self.navigationController?.popViewController(animated: true)
         
    }

    @objc func didTapDeleteButton(sender: AnyObject) {

        guard let editingView = editingView else { return }
        editingView.removeFromSuperview()
        
        helperView.removeFromSuperview()
     
    }

    @objc func didTapDownButton(sender: AnyObject) {

        guard let editingView = editingView else { return }
   
        guard let index = designView.subviews.firstIndex(of: editingView) else { return }
        
        switch index {
            
        case 0: break
            
        default:
            designView.insertSubview(editingView, at: index-1)
        }
        
        //Navigationbar for UIImageView
        if index == 1 {
            
            self.navigationItem.rightBarButtonItems?[1].isEnabled = false
        }
        
        if index == designView.subviews.count-2 {
            
            self.navigationItem.rightBarButtonItems?[2].isEnabled = true
          
        }

    }

    @objc func didTapUpButton(sender: AnyObject) {

        guard let editingView = editingView else { return }
        
        guard let index = designView.subviews.firstIndex(of: editingView) else { return }
        
        switch index {
        case designView.subviews.count-2:
            break
        default:
            designView.insertSubview(editingView, at: index+1)
        }
        
        //Navigationbar for UIImageView
        if index == designView.subviews.count-3 {
                self.navigationItem.rightBarButtonItems?[2].isEnabled = false
        }
        
        if index == 0 {
            
            self.navigationItem.rightBarButtonItems?[1].isEnabled = true
            
        }
        
    }

    @objc func didTapCopyButton(sender: AnyObject) {
        
        helperView.removeFromSuperview()
        
        var newView = UIView()
        
        if let tappedView = editingView as? ALTextView {
            
            newView = tappedView.makeACopy()
            
        } else if let tappedView = editingView as? ALImageView {
            
            newView = tappedView.makeACopy()
            
        } else if let tappedView = (editingView as? ALShapeView) {
            
            newView = tappedView.makeACopyShape()
            
        }
        
        addTapGesture(to: newView)
        
        designView.addSubview(newView)
        
        editingView = newView
        
    }
}
