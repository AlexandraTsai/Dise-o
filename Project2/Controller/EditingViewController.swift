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
class EditingViewController: UIViewController {

    @IBOutlet weak var currentFontBtn: UIButton! {
        
        didSet {
            
            currentFontBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            
        }
      
    }
    
    @IBOutlet weak var alignmentButton: UIButton!
    @IBOutlet weak var letterCaseButton: UIButton!
    @IBOutlet weak var fontTableView: UITableView! {

        didSet {
            fontTableView.delegate = self
            fontTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var italicButton: UIButton!
    @IBOutlet weak var boldbutton: UIButton!
    @IBOutlet weak var fontSizeBtn: UIButton! {
        
        didSet {
            
            fontSizeBtn.layer.cornerRadius = 8
            
            fontSizeBtn.layer.shadowOpacity = 1
            fontSizeBtn.layer.shadowRadius = 2
            fontSizeBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
            fontSizeBtn.layer.shadowColor = UIColor.DSColor.heavyGray.cgColor
            
        }
        
    }
    @IBOutlet weak var colorButton: UIButton! {
        
        didSet {
            
            colorButton.layer.cornerRadius = 8
            
            colorButton.layer.shadowOpacity = 1
            colorButton.layer.shadowRadius = 2
            colorButton.layer.shadowOffset = CGSize(width: 0, height: 0)
            colorButton.layer.shadowColor = UIColor.DSColor.heavyGray.cgColor
            
        }
        
    }
    
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
    @IBOutlet weak var selectFontView: UIView!
    @IBOutlet weak var rotationView: UIView!
    @IBOutlet weak var rotateSlider: UISlider!
    
    @IBOutlet weak var addElementButton: UIButton! {
        
        didSet {
            
            addElementButton.layer.cornerRadius = addElementButton.frame.width/2
            addElementButton.clipsToBounds = true
            addElementButton.setImage(ImageAsset.Icon_add_button.imageTemplate, for: .normal)
            addElementButton.tintColor = UIColor.DSColor.yellow
            addElementButton.backgroundColor = UIColor.white
            
        }
        
    }
    
    deinit {
        print("EditingViewController deinit \(self)")
    }
    
    var textContainerVC: TextContainerViewController?
    var imageContainerVC: ImageEditContainerViewController?
    var lineHeight: Float = 0
    var letterSpacing: Float = 0
    var currentFontName: FontName = FontName.helveticaNeue
    
    var helperView = HelperView()

    var editingView: UIView? {

        didSet {
            
            guard let editingView = editingView else {
                return
            }
            disableNavigationButton()
            rotationView.isHidden = true
            helperView = HelperView()
            
            createEditingHelper(for: editingView)
            
            guard let textView = editingView as? ALTextView else {

               textEditView.isHidden = true
               imageEditContainerView.isHidden = false

                guard let view = editingView as? ALShapeView else {
                    
                    guard let view = editingView as? UIImageView else { return }
                    
//                    imageContainerVC?.filterBtn.isSelected = true
                    imageContainerVC?.transparencyView.isHidden = true
                    imageContainerVC?.transparencyBtn.isSelected = false
                    
                    let alpha = view.alpha
                   
                    imageContainerVC?.slider.value = Float(alpha*100)
                    imageContainerVC?.transparencyLabel.text = "\(Int(Float(alpha*100)))"
                    
                    return
                    
                }
                
                let notificationName = Notification.Name(NotiName.paletteColor.rawValue)
                
                NotificationCenter.default.post(name: notificationName,
                                                object: nil,
                                                userInfo: [NotificationInfo.paletteColor: view.shapeColor])
                
               return

            }
        
            textView.delegate = self
            
            guard let alpha = textView.textColor?.cgColor.alpha else { return }
            textContainerVC?.slider.value = Float(alpha*100)
            colorButton.backgroundColor = textView.textColor?.withAlphaComponent(1)
        
            textEditView.isHidden = false
            imageEditContainerView.isHidden = true
            
        }
    }

    let fusuma = FusumaViewController()
    var tableViewIndex: Int = 0
    var originalText = ""

    @IBOutlet weak var designView: ALDesignView! {
        
        didSet {
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing(sender:)))
            
            designView.addGestureRecognizer(tap)
            
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

    override func viewDidLoad() {
        super.viewDidLoad()

        fontTableView.al_registerCellWithNib(identifier: String(describing: FontTableViewCell.self), bundle: nil)
        fontTableView.al_registerCellWithNib(identifier: String(describing: SpacingTableViewCell.self), bundle: nil)
        fontTableView.al_registerCellWithNib(identifier: String(describing: FontSizeTableViewCell.self), bundle: nil)

        setupImagePicker()
        createNotification()
        selectFontView.isHidden = true
        
        imageContainerVC?.slider.addTarget(self,
                                           action: #selector(editImageTransparency(sender:)),
                                           for: .valueChanged)
    }

    @IBAction func addBtnTapped(_ sender: Any) {
      
        helperView.removeFromSuperview()
        
        /*Notification*/
        let notificationName = Notification.Name(NotiName.addingMode.rawValue)
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.addingMode: true])
        
        let notificationName2 = Notification.Name(NotiName.updateImage.rawValue)
        NotificationCenter.default.post(
            name: notificationName2,
            object: nil,
            userInfo: [NotificationInfo.editedImage: designView.subviews])
      
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func fontButtonTapped(_ sender: Any) {

        tableViewIndex = 0

        fontTableView.isScrollEnabled = true
        fontTableView.reloadData()
        selectFontView.isHidden = false

    }

    @IBAction func colorButtonTapped(_ sender: Any) {

        selectFontView.isHidden = true
        textEditView.isHidden = true
        
        let notificationName = Notification.Name(NotiName.addElementButton.rawValue)
        
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.addElementButton: false])
    }
    @IBAction func fontSizeButtonTapped(_ sender: Any) {

        tableViewIndex = 2
        fontTableView.reloadData()
        selectFontView.isHidden = false

    }

    @IBAction func alignmentButtonTapped(_ sender: Any) {

        guard let view =  editingView as? ALTextView else { return }

        switch view.textAlignment {
        case .center:
            view.textAlignment = .right
            alignmentButton.setImage(UIImage(named: ImageAsset.Icon_AlignRight.rawValue), for: .normal)
        case .right:
            view.textAlignment = .left
             alignmentButton.setImage(UIImage(named: ImageAsset.Icon_AlignLeft.rawValue), for: .normal)
        default:
            view.textAlignment = .center
            alignmentButton.setImage(UIImage(named: ImageAsset.Icon_AlignCenter.rawValue), for: .normal)
        }

    }

    @IBAction func finishEdit(_ sender: Any) {
        selectFontView.isHidden = true

    }
    @IBAction func rotationDone(_ sender: Any) {
        rotationView.isHidden = true
    }
    
    @IBAction func boldButtonTapped(_ sender: Any) {

        guard let view =  editingView as? ALTextView else { return }

        switch boldbutton.currentTitleColor {

        case UIColor(red: 234/255, green: 183/255, blue: 31/255, alpha: 1):

            switch italicButton.currentTitleColor {
            case UIColor(red: 234/255, green: 183/255, blue: 31/255, alpha: 1):

                view.font = UIFont(name: currentFontName.italicStyle(), size: (view.font?.pointSize)!)

            default:
                view.font = UIFont(name: currentFontName.rawValue, size: (view.font?.pointSize)!)

            }

            boldbutton.setTitleColor(UIColor.white, for: .normal)
        default:

            switch italicButton.currentTitleColor {
            case UIColor(red: 234/255, green: 183/255, blue: 31/255, alpha: 1):

                view.font = UIFont(name: currentFontName.boldItalicStyle(), size: (view.font?.pointSize)!)

            default:
                view.font = UIFont(name: currentFontName.boldStyle(), size: (view.font?.pointSize)!)
            }

            boldbutton.setTitleColor(UIColor(red: 234/255, green: 183/255, blue: 31/255, alpha: 1), for: .normal)

        }

    }

    @IBAction func italicButtonTapped(_ sender: Any) {

        guard let view =  editingView as? ALTextView else { return }

        switch italicButton.currentTitleColor {

        case UIColor(red: 234/255, green: 183/255, blue: 31/255, alpha: 1):

            switch boldbutton.currentTitleColor {
            case UIColor(red: 234/255, green: 183/255, blue: 31/255, alpha: 1):

                view.font = UIFont(name: currentFontName.boldStyle(), size: (view.font?.pointSize)!)

            default:

                view.font = UIFont(name: currentFontName.rawValue, size: (view.font?.pointSize)!)

            }

            italicButton.setTitleColor(UIColor.white, for: .normal)

        default:

            switch boldbutton.currentTitleColor {
            case UIColor(red: 234/255, green: 183/255, blue: 31/255, alpha: 1):

                view.font = UIFont(name: currentFontName.boldItalicStyle(), size: (view.font?.pointSize)!)
            default:

                view.font = UIFont(name: currentFontName.italicStyle(), size: (view.font?.pointSize)!)
            }

            italicButton.setTitleColor(UIColor(red: 234/255, green: 183/255, blue: 31/255, alpha: 1), for: .normal)

        }

    }

    @IBAction func letterCaseBtnTapped(_ sender: Any) {

        guard let view =  editingView as? ALTextView else { return }

        switch letterCaseButton.titleLabel?.text {

        case "Aa":

            originalText = view.text

            view.text = view.text.uppercased()

            letterCaseButton.setTitle("AA", for: .normal)

        default:

            letterCaseButton.setTitle("Aa", for: .normal)
            view.text = originalText

        }

    }
    @IBAction func spacingBtnTapped(_ sender: Any) {

        tableViewIndex = 1

        fontTableView.isScrollEnabled = false
        fontTableView.reloadData()
        fontTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)

        selectFontView.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        guard designView.subviews.count > 0 else { return }

        for count in 0...designView.subviews.count-1
            where designView.subviews[count] != helperView {
            
                addTapGesture(to: designView.subviews[count])
            
        }
         rotationView.isHidden = true
 
    }
    @IBAction func slideToRotate(_ sender: UISlider) {
        
        let transform = CGAffineTransform(rotationAngle: CGFloat(sender.value/360)*CGFloat.pi*2)

        //To keep the transformation
        let xScale = helperView.transform.scaleX
        let yScale = helperView.transform.scaleY
        helperView.transform = transform.scaledBy(x: xScale, y: yScale)
      
        //Get the center of editingFrame from helperView to designView
        let center = helperView.convert(helperView.editingFrame.center, to: designView)
        
        //Make editingView's center equal to editingFrame's center
        editingView?.center = center
        
        editingView?.transform = helperView.transform
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "textSegue" {
            textContainerVC = segue.destination as? TextContainerViewController
        } else if segue.identifier == "imageSegue" {
            imageContainerVC = segue.destination as? ImageEditContainerViewController
           
        }
    }
    
    @objc func editImageTransparency(sender: UISlider) {
        editingView?.alpha = CGFloat(sender.value/100)
    }

}

//Setup Navigation Bar
extension EditingViewController {

    func normalNavigationBar() {

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

    func complexNavigationBar() {
        let button1 = UIBarButtonItem(
            image: UIImage(named: ImageAsset.Icon_Crop.rawValue),
            style: .plain,
            target: self,
            action: #selector(didTapCropButton(sender:)))

        let button2 = UIBarButtonItem(
            image: UIImage(named: ImageAsset.Icon_TrashCan.rawValue),
            style: .plain,
            target: self,
            action: #selector(didTapDeleteButton(sender:)))

        let button3 = UIBarButtonItem(
            image: UIImage(named: ImageAsset.Icon_down.rawValue),
            style: .plain,
            target: self,
            action: #selector(didTapDownButton(sender:)))

        let button4 = UIBarButtonItem(
            image: UIImage(named: ImageAsset.Icon_up.rawValue),
            style: .plain,
            target: self,
            action: #selector(didTapUpButton(sender:)))

        let button5 = UIBarButtonItem(
            image: UIImage(named: ImageAsset.Icon_Copy.rawValue),
            style: .plain,
            target: self,
            action: #selector(didTapCopyButton(sender:)))

        self.navigationItem.rightBarButtonItems  = [button1, button2, button3, button4, button5]

        //Left Buttons
        let leftButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(didTapDoneButton(sender:)))
        self.navigationItem.leftBarButtonItem  = leftButton

    }
    
    func disableNavigationButton() {
        
        guard let editingView = editingView else { return }
        
        guard let index = designView.subviews.firstIndex(of: editingView) else { return }
        
        if editingView is ALImageView {
            
            complexNavigationBar()
        } else {
            normalNavigationBar()
        }
        
        switch index {
            
        //Editing view is the last one
        case 0:
            
            guard (editingView as? UIImageView) != nil else {
                
                self.navigationItem.rightBarButtonItems?[1].isEnabled = false
                return
            }
            
            self.navigationItem.rightBarButtonItems?[2].isEnabled = false
            
         //Editing view is the first one
        case designView.subviews.count-1:
            
            guard (editingView as? UIImageView) != nil else {
                self.navigationItem.rightBarButtonItems?[2].isEnabled = false
                return
            }
            self.navigationItem.rightBarButtonItems?[3].isEnabled = false
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

        self.navigationController?.popViewController(animated: false)
        
        let notificationName2 = Notification.Name(NotiName.addingMode.rawValue)
        NotificationCenter.default.post(
            name: notificationName2,
            object: nil,
            userInfo: [NotificationInfo.addingMode: false])
        
    }

    @objc func didTapCropButton(sender: AnyObject) {

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
        
        //Navigationbar for ALTextView/ShapeView
        guard (editingView as? ALTextView) != nil || (editingView as? ALShapeView) != nil else {
            
            if index == 1 {
                self.navigationItem.rightBarButtonItems?[2].isEnabled = false
              
            }
            
            if index == designView.subviews.count-2 {
                
              self.navigationItem.rightBarButtonItems?[3].isEnabled = true
            }
            
            return
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
        
        //Navigationbar for ALTextView/ShapeView
        guard (editingView as? ALTextView) != nil || (editingView as? ALShapeView) != nil else {
            
            if index == designView.subviews.count-3 {
                
                //Disable the forward button.
                self.navigationItem.rightBarButtonItems?[3].isEnabled = false
                
            }
            
            if index == 0 {
                
                self.navigationItem.rightBarButtonItems?[2].isEnabled = true
            }
            
            return
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

            guard let tappedView = (editingView as? UIImageView)else {
                
                guard let tappedView = (editingView as? ALShapeView) else { return }
                
                let newView = tappedView.makeACopyShape()
                
                addTapGesture(to: newView)
                
                designView.addSubview(newView)
                
                editingView = newView
               
                return
                
            }

            let newView = UIImageView()

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
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCircleGesture(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        rotateView.addGestureRecognizer(tap)
    }
    
    func addPanGesture(to view: UIView) {
        view.isUserInteractionEnabled = true
        
        //Handle to tapped
        let pan = UIPanGestureRecognizer(target: self,
                                         action: #selector(handleDragged(_:)))
        
        view.addGestureRecognizer(pan)
    }
   
    @objc func endEditing(sender: UITapGestureRecognizer) {
        
        helperView.removeFromSuperview()
        
        let notificationName2 = Notification.Name(NotiName.updateImage.rawValue)
        NotificationCenter.default.post(
            name: notificationName2,
            object: nil,
            userInfo: [NotificationInfo.editedImage: designView.subviews])
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func handleDoubleTap(sender: UITapGestureRecognizer) {
      
        guard let textView = editingView as? ALTextView else { return }
        
        textView.addDoneButtonOnKeyboard()
        
        textView.becomeFirstResponder()
        
    }
    
    @objc func tapHelperView(sender: UITapGestureRecognizer) {
        
        if let textView = editingView as? ALTextView {
            
            textView.addDoneButtonOnKeyboard()
            
            textView.becomeFirstResponder()
            
        } else {
            
            helperView.alpha = 0
            
            UIView.animate(withDuration: 0.2) {  [weak self] in
                
                self?.helperView.alpha = 1
            }
            
        }
       
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        helperView.removeFromSuperview()
        
        editingView = sender.view

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
        
            //Get the center of editingFrame from helperView to designView
            let center = sender.view!.convert(helperView.editingFrame.center, to: designView)
            
            //Make editingView's center equal to editingFrame's center
            editingView?.center = center
            
            editingView?.transform = rotateValue
        
            sender.rotation = 0
            
        }

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
    }
    
    @objc func handleCircleGesture(sender: UITapGestureRecognizer) {

        rotationView.isHidden = false
        
        guard let rotateDegree = editingView?.transform.angleInDegrees else { return }
        
        if Int(rotateDegree) >= 0 {
            rotateSlider.value = Float(Int(rotateDegree))
            
        } else {
              rotateSlider.value = Float(360-Int(rotateDegree)*(-1))
        }
        
    }
    
    @objc func handleLeftHelper(sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: designView)
        
        guard let editingView = editingView else { return }
        
        let distance = CGPointDistance(from: editingView.center, to: location)
        
        let reduce = editingView.bounds.width-distance
        
        let oldCenter =  editingView.center
        
        let angle = editingView.transform.angle
        
        let transform = editingView.transform

        editingView.transform = CGAffineTransform(rotationAngle: 0)
        
        editingView.frame = CGRect(x: editingView.frame.origin.x+reduce,
                                   y: editingView.frame.origin.y,
                                   width: editingView.frame.width-reduce,
                                   height: editingView.frame.height)
        
        editingView.center = rotatePoint(target: editingView.center, aroundOrigin: oldCenter, byDegree: angle)
        
        editingView.transform = transform
        
        if let textView = editingView as? UITextView {
            
            textView.resize()
            
        }

        helperView.resize(accordingTo: editingView)
        
    }
    
    @objc func handleRightHelper(sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: designView)
        
        guard let editingView = editingView else { return }
        
        let distance = CGPointDistance(from: editingView.center, to: location)
        
        let reduce = editingView.bounds.width-distance
        
        let oldCenter =  editingView.center
        
        let angle = editingView.transform.angle
        
        let transform = editingView.transform
        
        editingView.transform = CGAffineTransform(rotationAngle: 0)
        
        editingView.frame = CGRect(x: editingView.frame.origin.x,
                                   y: editingView.frame.origin.y,
                                   width: editingView.frame.width-reduce,
                                   height: editingView.frame.height)
        
        editingView.center = rotatePoint(target: editingView.center, aroundOrigin: oldCenter, byDegree: angle)
        
        editingView.transform = transform
        
        if let textView = editingView as? UITextView {
    
            textView.resize()
            
        }
        
        helperView.resize(accordingTo: editingView)
        
    }
    
    @objc func handleTopHelper(sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: designView)
        
        guard let editingView = editingView else { return }
        
        let distance = CGPointDistance(from: editingView.center, to: location)
        
        let reduce = editingView.bounds.height-distance
        
        let oldCenter =  editingView.center
        
        let angle = editingView.transform.angle
        
        let transform = editingView.transform
        
        editingView.transform = CGAffineTransform(rotationAngle: 0)
        
        editingView.frame = CGRect(x: editingView.frame.origin.x,
                                   y: editingView.frame.origin.y+reduce,
                                   width: editingView.frame.width,
                                   height: editingView.frame.height-reduce)
        
        editingView.center = rotatePoint(target: editingView.center, aroundOrigin: oldCenter, byDegree: angle)
        
        editingView.transform = transform
        
        helperView.resize(accordingTo: editingView)
        
    }
    
    @objc func handleBottomHelper(sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: designView)
        
        print("-------------------------")
        print(location)
        
        guard let editingView = editingView else { return }
        
        print(editingView.frame)
        
        let distance = CGPointDistance(from: editingView.center, to: location)
        
        let reduce = editingView.bounds.height-distance
        
        let oldCenter =  editingView.center
        
        let angle = editingView.transform.angle
        
        let transform = editingView.transform
        
        editingView.transform = CGAffineTransform(rotationAngle: 0)
        
        print(editingView.frame)
        
        editingView.frame = CGRect(x: editingView.frame.origin.x,
                                   y: editingView.frame.origin.y,
                                   width: editingView.frame.width,
                                   height: editingView.frame.height-reduce)
        
        editingView.center = rotatePoint(target: editingView.center, aroundOrigin: oldCenter, byDegree: angle)
        
        editingView.transform = transform
        
        print(editingView.frame)
        
        helperView.resize(accordingTo: editingView)
        
    }
    
    // swiftlint:disable identifier_name
    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    // swiftlint:enable identifier_name
    
    func rotatePoint(target: CGPoint, aroundOrigin origin: CGPoint, byDegree: CGFloat) -> CGPoint {
        
        let distanceX = target.x - origin.x
        let distanceY = target.y - origin.y
        
        let radius = sqrt(distanceX*distanceX+distanceY*distanceY)
        
        let azimuth = atan2(distanceY, distanceX)
        let newAzimuth = azimuth + byDegree*CGFloat.pi/180.0
        
        let newX = origin.x + radius*cos(newAzimuth)
        let newY = origin.y + radius*sin(newAzimuth)
        
        return CGPoint(x: newX, y: newY)
        
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

                    originalText.removeLast()
                }

                return

            }

            //Remove the text that original text already has
            for _ in 1...originalText.count {

                newText.removeFirst()

            }

            originalText.append(newText)

            textView.text = textView.text.uppercased()

        default:

            originalText = textView.text

        }
        
        helperView.resize(accordingTo: textView)

    }
}

extension EditingViewController: UITableViewDelegate, UITableViewDataSource,
            SpacingTableViewCellDelegate, FontSizeTableViewCellDelegate {
    
//    func scrollToRow(at index: IndexPath, with: UITableView.ScrollPosition, animated: Bool) {
//
//        DispatchQueue.main.async {
//            let index = IndexPath(row: index.row, section: 0)
//
//            fontTableView.scrollToRow(at: index,at: .middle, animated: true) //here .middle is the scroll position can change it as per your need
//        }
//
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch tableViewIndex {
        case 0:

            return FontName.allCases.count
        default:

            return 1
        }

    }

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

            spacingCell.delegate = self

            return spacingCell
        default:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: FontSizeTableViewCell.self),
                for: indexPath)

            guard let fontSizeCell = cell as? FontSizeTableViewCell else { return cell }

            guard let view = editingView as? ALTextView else { return cell }
            guard let fontSize = view.font?.pointSize else {return cell}

            fontSizeCell.delegate = self

            fontSizeCell.fontSizeLabel.text = "\(Int(fontSize))"
            return fontSizeCell

        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch tableViewIndex {
        case 0:
            guard let view = editingView as? ALTextView,
                let fontSize = view.font?.pointSize else { return }

            let fontName = FontName.allCases[indexPath.row].rawValue

            guard let newFont = UIFont(name: fontName, size: fontSize) else {
                return
            }

            view.font = newFont
            
            view.resize()

            currentFontName = FontName.allCases[indexPath.row]

            currentFontBtn.setTitle(fontName, for: .normal)
            currentFontBtn.titleLabel?.font = UIFont(name: fontName, size: 20)
            
            tableView.reloadData()

            //Setup rBold and Italic Buttons
            switch FontName.allCases[indexPath.row].fontStyle() {
            case 0:
                boldbutton.disableMode()
                italicButton.disableMode()
            case 1:
                boldbutton.enableMode()
                italicButton.disableMode()
            case 2:
                boldbutton.disableMode()
                italicButton.enableMode()
            case 3, 4:
                boldbutton.enableMode()
                italicButton.enableMode()

            default:
                break
            }

        default:
            break
        }

    }

    func changeTextAttributeWith(lineHeight: Float, letterSpacing: Float) {

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

    func changeFontSize(to size: Int) {
        
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
        
        fontSizeBtn.setTitle(String(size), for: .normal)
    }
    
}

// MARK: - Fusuma image picker
extension EditingViewController: FusumaDelegate {
    
    //Notification for image picked
    func createNotification() {
        
        // 註冊addObserver
        let notificationName = Notification.Name(NotiName.changeImage.rawValue)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeImage(noti:)), name: notificationName, object: nil)
        
        let notificationName2 = Notification.Name(NotiName.changeEditingViewColor.rawValue)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeEditingViewColor(noti:)), name: notificationName2, object: nil)
        
        let notificationName3 = Notification.Name(NotiName.addElementButton.rawValue)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(showOrHideButton(noti:)), name: notificationName3, object: nil)
        
        let notificationName4 = Notification.Name(NotiName.textTransparency.rawValue)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeTextTransparency(noti:)), name: notificationName4, object: nil)
        
        let notificationName5 = Notification.Name(NotiName.textColor.rawValue)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeTextColor(noti:)), name: notificationName5, object: nil)
    }
    
    // 收到通知後要執行的動作
    @objc func changeImage(noti: Notification) {
        if let userInfo = noti.userInfo,
            let mode = userInfo[NotificationInfo.changeImage] as? Bool {
            
            if mode == true {
                self.present(fusuma, animated: true, completion: nil)
                print(fusuma)
            }
        }
    }
    
    @objc func changeEditingViewColor(noti: Notification) {
        
        if let userInfo =  noti.userInfo,
            let color = userInfo[NotificationInfo.changeEditingViewColor] as? UIColor {
            
            guard let view = editingView as? UIImageView else {
                
                guard let view = editingView as? ALShapeView else { return }
 
                    view.shapeColor = color
                    view.setNeedsDisplay()

                    return
            }
            view.image = nil
            view.backgroundColor = color
                
        }
    }
    
    @objc func showOrHideButton(noti: Notification) {
        if let userInfo = noti.userInfo,
            let mode = userInfo[NotificationInfo.addElementButton] as? Bool {
            
            if mode == true {
                addElementButton.isHidden = false
                
                if editingView as? ALTextView != nil {
                     textEditView.isHidden = false
                }
                
            } else {
                addElementButton.isHidden = true
            }
        }
    }
    
    //Text Attribute
    @objc func changeTextColor(noti: Notification) {
        if let userInfo = noti.userInfo,
            let color = userInfo[NotificationInfo.textColor] as? UIColor {
            
            guard let textView = editingView as? ALTextView else { return }
            
            guard let alpha = textView.textColor?.cgColor.alpha else { return }
            
            textView.textColor = color.withAlphaComponent(alpha)
            colorButton.backgroundColor = color
        }
    }
    @objc func changeTextTransparency(noti: Notification) {
        if let userInfo = noti.userInfo,
            let transparency = userInfo[NotificationInfo.textTransparency] as? CGFloat {
            
            guard let textView = editingView as? ALTextView else { return }
            
            let color = textView.textColor
            
            textView.textColor = color?.withAlphaComponent(transparency)
            
        }
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
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        guard let imageView = editingView as? UIImageView else {
            return
        }
        
        imageView.image = image
//        imageView.backgroundColor = UIColor.red
 
        let notificationName = Notification.Name(NotiName.didChangeImage.rawValue)
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.didChangeImage: true])
    }

    // Return the image but called after is dismissed.
    private func fusumaDismissedWithImage(image: UIImage, source: FusumaMode) {
       
        print("dismiss")
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
// MARK: EditingVC extension
extension EditingViewController {
    
    func createEditingHelper(for view: UIView) {
        
        designView.addSubview(helperView)
        
        guard let editingView = editingView else { return }
        
        helperView.resize(accordingTo: editingView)

        let center = editingView.center
        
        let rect = designView.convert(center, to: helperView)
        
        helperView.editingFrame.center = rect
        helperView.editingFrame.bounds = (editingView.bounds)

        helperView.layoutIfNeeded()
        editingView.layoutIfNeeded()
        helperView.rotateHelper.layoutIfNeeded()
        helperView.positionHelper.layoutIfNeeded()

        addAllGesture(to: helperView)
        
//        helperView.clipsToBounds = false
        helperView.isUserInteractionEnabled = true
        
        addCircleGesture(to: helperView.rotateHelper)
        addPanGesture(to: helperView.positionHelper)
        
        //Handle to tapped
        let pan = UIPanGestureRecognizer(target: self,
                                         action: #selector(handleLeftHelper(sender:)))
        
        helperView.leftHelper.addGestureRecognizer(pan)
        
        let pan2 = UIPanGestureRecognizer(target: self,
                                          action: #selector(handleRightHelper(sender:)))
        
        helperView.rightHelper.addGestureRecognizer(pan2)
        
        let pan3 = UIPanGestureRecognizer(target: self,
                                          action: #selector(handleTopHelper(sender:)))
        
        helperView.topHelper.addGestureRecognizer(pan3)
        
        let pan4 = UIPanGestureRecognizer(target: self,
                                          action: #selector(handleBottomHelper(sender:)))
        
        helperView.bottomHelper.addGestureRecognizer(pan4)
        
        if editingView is UIImageView {
            
            helperView.withoutResizeHelper()
            
        } else if editingView is UITextView {
            
            helperView.withWidthHelper()
            
        } else if editingView is UITextView {
            
            helperView.withResizeHelper()
            
        }
        
    }
    
}
 // swiftlint:enable file_length
