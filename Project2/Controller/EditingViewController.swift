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

// swiftlint:disable file_length
class EditingViewController: BaseViewController {

    @IBOutlet weak var currentFontBtn: UIButton! {
        
        didSet {
            
            currentFontBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            
        }
      
    }
    
    @IBOutlet weak var alignmentButton: UIButton!
    @IBOutlet weak var letterCaseButton: UIButton!
    
    @IBOutlet weak var italicButton: UIButton!
    @IBOutlet weak var boldbutton: UIButton!
    
    @IBOutlet weak var textEditView: UIView!
    
    @IBOutlet weak var textToolView: UIView! {
        
        didSet {
            
            textToolView.layer.cornerRadius = 6
            
            textToolView.layer.shadowColor = UIColor.DSColor.heavyGray.cgColor
            textToolView.layer.shadowOffset = CGSize(width: 0, height: 0)
            textToolView.layer.shadowRadius = 6
            textToolView.layer.shadowOpacity = 1
            
        }
        
    }
    
    @IBOutlet weak var imageEditContainerView: UIView!
    @IBOutlet weak var textEditContainterView: UIView!
    
    @IBOutlet weak var selectFontView: UIView!
   
    @IBOutlet weak var addElementButton: UIButton! {
        
        didSet {
            
            addElementButton.layer.cornerRadius = addElementButton.frame.width/2
            addElementButton.clipsToBounds = true
            addElementButton.setImage(ImageAsset.Icon_add_button.imageTemplate, for: .normal)
            addElementButton.tintColor = UIColor.DSColor.yellow
            addElementButton.backgroundColor = UIColor.white
            
        }
        
    }
    
    let openLibraryAlert = GoSettingAlertView()
    
    let openCameraAlert = GoSettingAlertView()
    
    var textContainerVC: TextContainerViewController?
    var imageContainerVC: ImageEditContainerViewController?
    var lineHeight: Float = 0
    var letterSpacing: Float = 0
    var currentFontName: FontName = FontName.helveticaNeue
    
    var helperView = HelperView()

    var oldLocation: CGPoint?
    
    var newLocation: CGPoint?
    
    var originLocation = CGPoint(x: 0, y: 0)
    
    var originSize = CGSize(width: 0, height: 0)
    
    var editingView: UIView? {

        didSet {
           
            guard let editingView = editingView else {
                return
            }
            disableNavigationButton()
            
            helperView = HelperView()
            
            createEditingHelper(for: editingView)
            
            guard let textView = editingView as? ALTextView else {

//               textEditView.isHidden = true
            
                textEditContainterView.isHidden = true
                imageEditContainerView.isHidden = false

                guard let view = editingView as? ALShapeView else {
                    
                    guard let view = editingView as? ALImageView else { return }
          
                    imageContainerVC?.editImageMode()
                    
                    let alpha = view.alpha
                   
                    imageContainerVC?.slider.value = Float(alpha*100)
                    imageContainerVC?.transparencyLabel.text = "\(Int(Float(alpha*100)))"
                    
                    if let image = view.originImage {
                        
                        delegate?.showAllFilter(for: image)
                    }
                    
                    return
                    
                }
                
                let alpha = view.alpha
                
                imageContainerVC?.slider.value = Float(alpha*100)
                
                imageContainerVC?.editShapeMode()

                let notificationName = Notification.Name(NotiName.paletteColor.rawValue)
                
                NotificationCenter.default.post(name: notificationName,
                                                object: nil,
                                                userInfo: [NotificationInfo.paletteColor: view.shapeColor])
                
               return

            }
        
            textView.delegate = self
            
            guard let alpha = textView.textColor?.cgColor.alpha else { return }
            textContainerVC?.slider.value = Float(alpha*100)
            textContainerVC?.textAlignment = textView.textAlignment
            textContainerVC?.currentFont = textView.font
            textContainerVC?.colorButton.backgroundColor = textView.textColor?.withAlphaComponent(1)
        
            imageEditContainerView.isHidden = true
            textEditContainterView.isHidden = false
            
        }
    }

    var tableViewIndex: Int = 0
    var originalText = ""
    
    @IBOutlet weak var designView: ALDesignView!
 
    @IBOutlet weak var shadowView: UIView! {
        
        didSet {
            
            shadowView.clipsToBounds = false
            shadowView.layer.shadowColor = UIColor.DSColor.mediumGray.cgColor
            shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
            shadowView.layer.shadowRadius = 10
            shadowView.layer.shadowOpacity = 0.6
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        createNotification()
        
        imageContainerVC?.slider.addTarget(self,
                                           action: #selector(editImageTransparency(sender:)),
                                           for: .valueChanged)
        
        self.view.addSubview(openLibraryAlert)
        self.view.addSubview(openCameraAlert)
      
        openLibraryAlert.alpha = 0
        openCameraAlert.alpha = 0
        
    }

    func alignmentChange(to type: NSTextAlignment) {
        
        guard let view =  editingView as? ALTextView else { return }
        view.textAlignment = type
        
    }
    
//    @IBAction func finishEdit(_ sender: Any) {
//        selectFontView.isHidden = true
//
//    }
  
//    @IBAction func boldButtonTapped(_ sender: Any) {
//
//        guard let view =  editingView as? ALTextView else { return }
//
//        switch boldbutton.currentTitleColor {
//
//        case UIColor(red: 234/255, green: 183/255, blue: 31/255, alpha: 1):
//
//            switch italicButton.currentTitleColor {
//            case UIColor(red: 234/255, green: 183/255, blue: 31/255, alpha: 1):
//
//                view.font = UIFont(name: currentFontName.italicStyle(), size: (view.font?.pointSize)!)
//
//            default:
//                view.font = UIFont(name: currentFontName.rawValue, size: (view.font?.pointSize)!)
//
//            }
//
//            boldbutton.setTitleColor(UIColor.white, for: .normal)
//        default:
//
//            switch italicButton.currentTitleColor {
//            case UIColor(red: 234/255, green: 183/255, blue: 31/255, alpha: 1):
//
//                view.font = UIFont(name: currentFontName.boldItalicStyle(), size: (view.font?.pointSize)!)
//
//            default:
//                view.font = UIFont(name: currentFontName.boldStyle(), size: (view.font?.pointSize)!)
//            }
//
//            boldbutton.setTitleColor(UIColor(red: 234/255, green: 183/255, blue: 31/255, alpha: 1), for: .normal)
//
//        }
//
//    }
//
//    @IBAction func italicButtonTapped(_ sender: Any) {
//
//        guard let view =  editingView as? ALTextView else { return }
//
//        switch italicButton.currentTitleColor {
//
//        case UIColor(red: 234/255, green: 183/255, blue: 31/255, alpha: 1):
//
//            switch boldbutton.currentTitleColor {
//            case UIColor(red: 234/255, green: 183/255, blue: 31/255, alpha: 1):
//
//                view.font = UIFont(name: currentFontName.boldStyle(), size: (view.font?.pointSize)!)
//
//            default:
//
//                view.font = UIFont(name: currentFontName.rawValue, size: (view.font?.pointSize)!)
//
//            }
//
//            italicButton.setTitleColor(UIColor.white, for: .normal)
//
//        default:
//
//            switch boldbutton.currentTitleColor {
//            case UIColor(red: 234/255, green: 183/255, blue: 31/255, alpha: 1):
//
//                view.font = UIFont(name: currentFontName.boldItalicStyle(), size: (view.font?.pointSize)!)
//            default:
//
//                view.font = UIFont(name: currentFontName.italicStyle(), size: (view.font?.pointSize)!)
//            }
//
//            italicButton.setTitleColor(UIColor(red: 234/255, green: 183/255, blue: 31/255, alpha: 1), for: .normal)
//
//        }
//
//    }

    @IBAction func letterCaseBtnTapped(_ sender: Any) {
        
        guard let view =  editingView as? ALTextView,
            let fontName = view.font?.fontName,
            let fontSize = view.font?.pointSize,
            let textColor = view.textColor else { return }
      
        switch letterCaseButton.titleLabel?.text {

        case "Aa":

            originalText = view.text

            view.text = view.text.uppercased()
        
            letterCaseButton.setTitle("AA", for: .normal)
            
            view.keepAttributeWith(lineHeight: self.lineHeight,
                                   letterSpacing: self.letterSpacing,
                                   fontName: fontName,
                                   fontSize: fontSize,
                                   textColor: textColor)

        default:

            letterCaseButton.setTitle("Aa", for: .normal)
            view.text = originalText
            
            view.keepAttributeWith(lineHeight: self.lineHeight,
                                   letterSpacing: self.letterSpacing,
                                   fontName: fontName,
                                   fontSize: fontSize,
                                   textColor: textColor)
            
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        guard designView.subviews.count > 0 else { return }

        for count in 0...designView.subviews.count-1
            where designView.subviews[count] != helperView {
            
                addTapGesture(to: designView.subviews[count])
            
        }
        
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == ALSegue.textSegue.rawValue {
            
            textContainerVC = segue.destination as? TextContainerViewController
            
            textContainerVC?.delegate = self
            
        } else if segue.identifier == ALSegue.imageSegue.rawValue {
            
            imageContainerVC = segue.destination as? ImageEditContainerViewController
            imageContainerVC?.delegate = self
            self.delegate = imageContainerVC
           
        }
    }
    
    @objc func editImageTransparency(sender: UISlider) {
        
        editingView?.alpha = CGFloat(sender.value/100)
    }
    
    override func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        guard let imageView = editingView as? ALImageView else {
            return
        }
        
        let fileName = String(Date().timeIntervalSince1970)
        
        saveImage(fileName: fileName, image: image)
        
        DispatchQueue.main.async { [weak imageView] in
            
            imageView?.image = image
            
        }
        
        imageView.imageFileName = fileName
        imageView.originImage = image
        
        self.delegate?.showAllFilter(for: image)
        self.delegate?.editImageMode()
        
        let notificationName = Notification.Name(NotiName.didChangeImage.rawValue)
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.didChangeImage: true])
    }

}

//Setup Navigation Bar
extension EditingViewController {

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
        
        leftButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: FontName.futura.rawValue,
                                                size: 17.0)
            ], for: .normal)
        
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
        
        default:
            break
        }
    }

    @objc func didTapDoneButton(sender: AnyObject) {
        
        helperView.removeFromSuperview()
        
        /*Notification*/
        let notificationName = Notification.Name(NotiName.updateImage.rawValue)
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.editedImage: designView.subviews])

        self.navigationController?.popViewController(animated: true)
        
        let notificationName2 = Notification.Name(NotiName.addingMode.rawValue)
        NotificationCenter.default.post(
            name: notificationName2,
            object: nil,
            userInfo: [NotificationInfo.addingMode: false])
        
    }

    @objc func didTapDeleteButton(sender: AnyObject) {

        guard let editingView = editingView else { return }
        editingView.removeFromSuperview()
        
        helperView.removeFromSuperview()
        
        /*Notification*/
        let notificationName = Notification.Name(NotiName.updateImage.rawValue)
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.editedImage: designView.subviews])
        
        self.navigationController?.popViewController(animated: false)

    }

    @objc func didTapDownButton(sender: AnyObject) {

        guard let editingView = editingView else { return }
   
        guard let index = designView.subviews.firstIndex(of: editingView) else { return }
        
        switch index {
        case 0:
            print("You are the last one.")
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

        guard let tappedView = (editingView as? ALTextView) else {

            guard let tappedView = (editingView as? ALImageView)else {
                
                guard let tappedView = (editingView as? ALShapeView) else { return }
                
                let newView = tappedView.makeACopyShape()

                addTapGesture(to: newView)
                
                designView.addSubview(newView)
                
                editingView = newView
               
                return
                
            }

            let newView = ALImageView()

            newView.makeACopy(from: tappedView)
            
            addTapGesture(to: newView)
            
            designView.addSubview(newView)
            
            editingView = newView

            return
        }

        let newView = ALTextView()

        newView.makeACopy(from: tappedView)

        addTapGesture(to: newView)
        
        designView.addSubview(newView)
        
        editingView = newView

    }
}

//Setup Gesture
extension EditingViewController {
    
    func addAllGesture(to helperView: UIView) {
        
        //Enable textView to rotate
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(sender:)))
        helperView.addGestureRecognizer(rotate)
        
        //Enable to move textView
        let move = UIPanGestureRecognizer(target: self, action: #selector(handleDragged(_ :)))
        helperView.addGestureRecognizer(move)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
        helperView.addGestureRecognizer(pinch)
        
        //Enable to edit textView
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        helperView.addGestureRecognizer(doubleTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHelperView(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        helperView.addGestureRecognizer(tap)

    }

    func addTapGesture(to newView: UIView) {

        newView.isUserInteractionEnabled = true

        //Handle to tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        newView.addGestureRecognizer(tap)
    }
    
    func addCircleGesture(to rotateView: UIView) {

        rotateView.isUserInteractionEnabled = true

        //Handle to tapped
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleCircleGesture(sender:)))
        rotateView.addGestureRecognizer(pan)
    }

    func addPanGesture(to view: UIView) {
        view.isUserInteractionEnabled = true

        //Handle to tapped
        let pan = UIPanGestureRecognizer(target: self,
                                         action: #selector(handleDragged(_:)))

        view.addGestureRecognizer(pan)
    }

    @objc func handleDoubleTap(sender: UITapGestureRecognizer) {
      
        guard let textView = editingView as? ALTextView else { return }
        
        textView.addDoneButtonOnKeyboard()
        
        textView.becomeFirstResponder()
        
        helperView.showHelper(after: sender)
        
    }
    
    @objc func tapHelperView(sender: UITapGestureRecognizer) {
        
        if let textView = editingView as? ALTextView {
            
            textView.addDoneButtonOnKeyboard()
            
            textView.becomeFirstResponder()
            
        } else {
            
            helperView.alpha = 0
            
            UIView.animate(withDuration: 0.2) {  [weak self] in
                
                self?.helperView.alpha = 1
                
                self?.helperView.showHelper(after: sender)
            }
            
        }
       
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        helperView.removeFromSuperview()
        
        editingView = sender.view
        
        helperView.showHelper(after: sender)

    }

    @objc func handleRotation(sender: UIRotationGestureRecognizer) {
        
        guard  sender.view != nil else {
            return

        }

        if sender.state == .began || sender.state == .changed {

            guard let rotateValue = sender.view?.transform.rotated(by: sender.rotation) else { return }
            
            sender.view?.transform = rotateValue
        
            //Get the center of editingFrame from helperView to designView
            guard let view = sender.view else { return }
            
            let center = view.convert(helperView.editingFrame.center, to: designView)
            
            //Make editingView's center equal to editingFrame's center
            editingView?.center = center
            
            editingView?.transform = rotateValue
        
            sender.rotation = 0
            
        }
        
        helperView.showHelper(after: sender)

    }

    @objc func handlePinch(sender: UIPinchGestureRecognizer) {

        guard  sender.view != nil else {
            return

        }

        if sender.state == .began || sender.state == .changed {
            
            guard let transform = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale) else {

                return
            }
          
            sender.view?.transform = transform
    
            guard let center = sender.view?.convert(helperView.editingFrame.center, to: designView) else { return }
            
            editingView?.center = center
            
            editingView?.transform = transform
            
            sender.scale = 1
            
            return
            
        }
        
        helperView.showHelper(after: sender)
    }

    @objc func handleDragged( _ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.view)

        guard let xCenter = editingView?.center.x, let yCenter = editingView?.center.y else { return }

        editingView?.center = CGPoint(x: xCenter+translation.x, y: yCenter+translation.y)
        gesture.setTranslation(CGPoint.zero, in: editingView)
        
        guard let center = editingView?.center else { return }
        helperView.center = center

        let view = gesture.view
        guard let xCenter2 = view?.center.x, let yCenter2 = view?.center.y else { return }

        view?.center = CGPoint(x: xCenter2+translation.x, y: yCenter2+translation.y)
        gesture.setTranslation(CGPoint.zero, in: view)
        
        helperView.showHelper(after: gesture)
        
    }
    
    @objc func handleCircleGesture(sender: UIPanGestureRecognizer) {
        
        helperView.rotateHelper.increaseHitInset()

        let state = sender.state
        
        switch state {
            
        case .began:
           
            originLocation = sender.location(in: designView)
          
        case .changed:
            
            if let location = newLocation { originLocation = location }
                
            newLocation = sender.location(in: designView)
        
            guard let origin = editingView?.center,
                let newLocation = newLocation else { return }
            
            let newAngle = angleBetween(pointA: originLocation,
                                       pointB: newLocation,
                                       origin: origin)
            
            var originAngle: CGFloat = 0

            guard let angle = editingView?.transform.angleInDegrees else { return }
           
            if isClockwise(from: originLocation, to: newLocation, center: origin) {
            
                originAngle = (angle/360)*CGFloat.pi*2
                
                if originAngle+newAngle >= CGFloat.pi*2 {
                    
                    editingView?.transform = CGAffineTransform(rotationAngle: originAngle+newAngle-CGFloat.pi*2)
                   
                } else {
                    
                    editingView?.transform =
                        CGAffineTransform(rotationAngle: originAngle+newAngle)
                    
                }
                
            } else {
                
                originAngle = (angle/360)*CGFloat.pi*2
                
                if originAngle-newAngle <= 0 {
                    
                    editingView?.transform = CGAffineTransform(rotationAngle: originAngle-newAngle+CGFloat.pi*2)
                    
                } else {
                    
                    editingView?.transform =
                        CGAffineTransform(rotationAngle: originAngle-newAngle)
                    
                }
                
            }
            
            guard let editingView = editingView else { return }
            
            helperView.resize(accordingTo: editingView)

        default:
   
            helperView.rotateHelper.decreaseHitInset()
            
            helperView.showHelper(after: sender)
        }
 
    }
    
    @objc func handleSizeHelper(sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: designView)
        
        guard let editingView = editingView,
            let helper = sender.view as? SizeHelperView else { return }
        
        let distance = CGPointDistance(from: editingView.center, to: location)
        
        var reduce = editingView.bounds.width-distance
        
        let oldCenter =  editingView.center
        
        let angle = editingView.transform.angle
        
        let transform = editingView.transform

        editingView.transform = CGAffineTransform(rotationAngle: 0)
        
        switch helper.direct {
        case .top?:
            
            reduce = editingView.bounds.height-distance
            
            editingView.frame = CGRect(x: editingView.frame.origin.x,
                                       y: editingView.frame.origin.y+reduce,
                                       width: editingView.frame.width,
                                       height: editingView.frame.height-reduce)
        case .bottom?:
            
            reduce = editingView.bounds.height-distance
            editingView.frame = CGRect(x: editingView.frame.origin.x,
                                       y: editingView.frame.origin.y,
                                       width: editingView.frame.width,
                                       height: editingView.frame.height-reduce)
        case .left?:
            editingView.frame = CGRect(x: editingView.frame.origin.x+reduce,
                                       y: editingView.frame.origin.y,
                                       width: editingView.frame.width-reduce,
                                       height: editingView.frame.height)
        case .right?:
            editingView.frame = CGRect(x: editingView.frame.origin.x,
                                       y: editingView.frame.origin.y,
                                       width: editingView.frame.width-reduce,
                                       height: editingView.frame.height)
        default: break
        }
        
        editingView.center = movePoint(target: editingView.center, aroundOrigin: oldCenter, byDegree: angle)
        
        editingView.transform = transform
        
        if let textView = editingView as? UITextView {
            
            textView.resize()
            
        }

        helperView.resize(accordingTo: editingView)
        
        helperView.showHelper(after: sender)
        
    }
}

extension EditingViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
 
        textView.resize()

        switch letterCaseButton.titleLabel?.text {
        case "AA":

            var newText = ""
            newText.append(textView.text)

            guard newText.count > 0  else { return }

            guard newText.count > originalText.count else {

                let count = originalText.count - newText.count

                for _ in  1...count {

                    textContainerVC?.originalText.removeLast()
                }

                return

            }

            //Remove the text that original text already has
            for _ in 1...originalText.count {

                newText.removeFirst()

            }

            textContainerVC?.originalText.append(newText)

            textView.text = textView.text.uppercased()

        default:

            textContainerVC?.originalText = textView.text

        }
        
        helperView.resize(accordingTo: textView)

    }
}

extension EditingViewController {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch tableViewIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: FontTableViewCell.self),
                for: indexPath)

            guard let fontCell = cell as? FontTableViewCell else { return cell }

            fontCell.fontLabel.text = FontName.allCases[indexPath.row].rawValue
            fontCell.fontLabel.font = UIFont(name: FontName.allCases[indexPath.row].rawValue, size: 18)
      
            if currentFontName == FontName.allCases[indexPath.row] {
                
                fontCell.fontLabel.textColor = UIColor.DSColor.yellow
                
            } else {
                
                fontCell.fontLabel.textColor = UIColor.black
                
            }
        
            return fontCell
        case 1:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SpacingTableViewCell.self),
                for: indexPath)

            guard let spacingCell = cell as? SpacingTableViewCell else { return cell }

//            spacingCell.delegate = self

            return spacingCell
            
        default:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: FontSizeTableViewCell.self),
                for: indexPath)

            guard let fontSizeCell = cell as? FontSizeTableViewCell else { return cell }

            guard let view = editingView as? ALTextView else { return cell }
            guard let fontSize = view.font?.pointSize else {return cell}

//            fontSizeCell.delegate = self

            fontSizeCell.fontSizeLabel.text = "\(Int(fontSize))"
            return fontSizeCell

        }

    }
    
    func changeTextWith(lineHeight: Float, letterSpacing: Float) {
        
        self.lineHeight = lineHeight
        self.letterSpacing = letterSpacing
        
        guard let view = editingView as? ALTextView,
            let fontName = view.font?.fontName,
            let fontSize = view.font?.pointSize,
            let textColor = view.textColor else { return }
        
        view.keepAttributeWith(lineHeight: lineHeight,
                               letterSpacing: letterSpacing,
                               fontName: fontName,
                               fontSize: fontSize,
                               textColor: textColor)
        view.resize()
        
        helperView.resize(accordingTo: view)

    }

    func changeFont(to size: Int) {
        
        guard let view = editingView as? ALTextView,
            let fontName = view.font?.fontName,
            let textColor = view.textColor else { return }

        view.keepAttributeWith(lineHeight: self.lineHeight,
                               letterSpacing: self.letterSpacing,
                               fontName: fontName,
                               fontSize: CGFloat(size),
                               textColor: textColor)

        view.font = UIFont(name: fontName, size: CGFloat(size))

        view.resize()
        
        createEditingHelper(for: view)
        
        textContainerVC?.fontSizeButton.setTitle(String(size), for: .normal)
    }
    
}

// MARK: - Fusuma image picker
extension EditingViewController {
    
    //Notification for image picked
    func createNotification() {
        
        // 註冊addObserver
        let notificationName = Notification.Name(NotiName.changeImageWithAlbum.rawValue)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(pickAnotherImage(noti:)), name: notificationName, object: nil)
        
        let notificationName1 = Notification.Name(NotiName.changeImageByCamera.rawValue)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeImageWithCamera(noti:)), name: notificationName1, object: nil)
        
        let notificationName2 = Notification.Name(NotiName.changeEditingViewColor.rawValue)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeEditingViewColor(noti:)), name: notificationName2, object: nil)
       
//        let notificationName3 = Notification.Name(NotiName.textTransparency.rawValue)
//
//        NotificationCenter.default.addObserver(self, selector:
//            #selector(changeTextTransparency(noti:)), name: notificationName3, object: nil)
//
//        let notificationName4 = Notification.Name(NotiName.textColor.rawValue)
//        
//        NotificationCenter.default.addObserver(self, selector:
//            #selector(changeTextColor(noti:)), name: notificationName4, object: nil)
    }
    
    // 收到通知後要執行的動作
    @objc func pickAnotherImage(noti: Notification) {
        if let userInfo = noti.userInfo,
            let mode = userInfo[NotificationInfo.changeImageWithAlbum] as? Bool {
            
            if mode == true {
                
                DispatchQueue.main.async { [weak self, fusumaAlbum] in
                    
                    self?.present(fusumaAlbum, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    @objc func changeImageWithCamera(noti: Notification) {
        
        if let userInfo = noti.userInfo,
            let mode = userInfo[NotificationInfo.changeImageByCamera] as? Bool {
            
            if mode == true {
                
                DispatchQueue.main.async { [weak self, fusumaCamera] in
                    
                    self?.present(fusumaCamera, animated: true, completion: nil)
                    
                }
                
            }
        }
    }
    
    @objc func changeEditingViewColor(noti: Notification) {
        
        if let userInfo =  noti.userInfo,
            let color = userInfo[NotificationInfo.changeEditingViewColor] as? UIColor {
            
            guard let view = editingView as? UIImageView else {
                
                guard let view = editingView as? ALShapeView else { return }
 
                view.redrawWith(color)
                
                return
            }
            view.image = nil
            view.backgroundColor = color
                
        }
    }
}
// MARK: EditingVC extension
extension EditingViewController {
    
    func createEditingHelper(for view: UIView) {
        
        designView.addSubview(helperView)
        
        guard let editingView = editingView else { return }
        
        helperView.resize(accordingTo: editingView)

        helperView.resizeEditingFrame(accordingTo: editingView)

        addAllGesture(to: helperView)

        helperView.isUserInteractionEnabled = true
        
        addCircleGesture(to: helperView.rotateHelper)
        
        addPanGesture(to: helperView.positionHelper)
        
        //Handle to tapped
        let pan = UIPanGestureRecognizer(target: self,
                                         action: #selector(handleSizeHelper(sender:)))
        
        helperView.leftHelper.addGestureRecognizer(pan)
        
        let pan2 = UIPanGestureRecognizer(target: self,
                                          action: #selector(handleSizeHelper(sender:)))
        
        helperView.rightHelper.addGestureRecognizer(pan2)
        
        let pan3 = UIPanGestureRecognizer(target: self,
                                          action: #selector(handleSizeHelper(sender:)))
        
        helperView.topHelper.addGestureRecognizer(pan3)
        
        let pan4 = UIPanGestureRecognizer(target: self,
                                          action: #selector(handleSizeHelper(sender:)))
        
        helperView.bottomHelper.addGestureRecognizer(pan4)
        
        if editingView is UIImageView {
            
            helperView.withoutResizeHelper()
            
        } else if editingView is UITextView {
            
            helperView.withWidthHelper()
            
        } else if editingView is UITextView {
            
            helperView.withResizeHelper()
            
        }
        
        addGestureTo(helperView.leftTopHelper)
        addGestureTo(helperView.leftBottomHelper)
        addGestureTo(helperView.rightTopHelper)
        addGestureTo(helperView.rightBottomHelper)
      
    }
    
    func addGestureTo(_ cornerHelper: CornerHelperView) {
        
        let pan = UIPanGestureRecognizer(target: self,
                                          action: #selector(handleCornerResize(gesture:)))
        
        cornerHelper.addGestureRecognizer(pan)
        
    }
    
}

extension EditingViewController: BaseContainerViewControllerProtocol {
    
    func changeColor(to color: UIColor) {
        
        guard let view = editingView as? UIImageView else {
            
            guard let view = editingView as? ALShapeView else { return }
            
            view.redrawWith(color)
            
            return
        }
        view.image = nil
        view.backgroundColor = color
        
    }
    
    func showPhotoLibrayAlert() {
        
        openLibraryAlert.alpha = 1
        openLibraryAlert.addOn(self.view)
        openLibraryAlert.titleLabel.text = AlertTitle.openPhotoLibrary.rawValue
    }
    
    func showCameraAlert() {
        
        openCameraAlert.alpha = 1
        openCameraAlert.addOn(self.view)
        openCameraAlert.titleLabel.text = AlertTitle.openCamera.rawValue
    }
    
    func changeImageWith(filter: FilterType?) {
        
        guard let imageView = editingView as? ALImageView else {
            return
        }
        
        guard let fileName = imageView.imageFileName else { return }
        
        let originImage = loadImageFromDiskWith(fileName: fileName)
        
        if let filter = filter {
            
            DispatchQueue.main.async { [weak imageView] in
                
                imageView?.image = originImage?.addFilter(filter: filter)
                
            }
            
            imageView.filterName = filter
            
        } else {
            
            DispatchQueue.main.async { [weak imageView] in
                
                imageView?.image = originImage
                
            }
          
            imageView.filterName = nil
            
        }
        
    }
}

extension EditingViewController: TextContainerProtocol {
    
    func changeFont(to font: UIFont) {
        
        guard let textView = editingView as? UITextView else { return }
        
        textView.font = font
//        textView.resize()
        
    }
    
    func changeFont(to fontName: FontName) {
        
        guard let view = editingView as? ALTextView,
            let fontSize = view.font?.pointSize else { return }
        
        view.font = UIFont(name: fontName.rawValue, size: fontSize)
        
        view.resize()
    }
    
    func beBold() {
        
    }
    
    func textTransparency(value: CGFloat) {
        
        guard let textView = editingView as? ALTextView else { return }
        
        let color = textView.textColor
        
        textView.textColor = color?.withAlphaComponent(value)
        
    }
    
    func textColorChange(to color: UIColor) {
        
        guard let textView = editingView as? ALTextView else { return }
        
        guard let alpha = textView.textColor?.cgColor.alpha else { return }
        
        textView.textColor = color.withAlphaComponent(alpha)
        
    }
    
//    func hideColorPicker() {
//
//        textEditView.isHidden = false
//    }
    
    @objc func handleCornerResize(gesture: UIPanGestureRecognizer) {
        
        let location = gesture.location(in: designView)
    
        var originDistance: CGFloat = 0
        
        var newDistance: CGFloat = 0
        
        switch gesture.state {
            
        case .began:
           
            originLocation = CGPoint(x: location.x,
                                         y: location.y)

            if let width = editingView?.bounds.width,
                let height = editingView?.bounds.height {

                originSize = CGSize(width: width, height: height)

            }
      
        case .changed:
            
            let location = gesture.location(in: designView)

            newDistance = CGPointDistance(from: location, to: (editingView?.center)!)

            originDistance = CGPointDistance(from: originLocation, to: (editingView?.center)!)

            let scale = newDistance/originDistance

            let width = (originSize.width)*scale

            let height = (originSize.height)*scale

            editingView?.bounds.size = CGSize(width: width, height: height)
 
            helperView.resize(accordingTo: editingView!)

            if let textView = editingView as? UITextView {
                
                textView.updateTextFont()

            }
            
        default:
            
            helperView.resize(accordingTo: editingView!)

            helperView.showHelper(after: gesture)
            
        }
       
    }
    
}
 // swiftlint:enable file_length
