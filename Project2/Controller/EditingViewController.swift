//
//  ImageEditViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/1.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit
import Fusuma

class EditingViewController: UIViewController {

    @IBOutlet weak var currentFontBtn: UIButton!
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
    @IBOutlet weak var fontSizeBtn: UIButton!
    @IBOutlet weak var textEditView: UIView!
    @IBOutlet weak var imageEditContainerView: UIView!
    @IBOutlet weak var selectFontView: UIView!
    
    var lineHeight: Float = 0
    var letterSpacing: Float = 0
    var currentFontName: FontName = FontName.helveticaNeue
    var helperView = UIView()
    
    let rotateHelper = UIImageView()
    let positionHelper = UIImageView()
    let editingFrame = UIView()
 
    var editingView: UIView? {

        didSet {

            guard let editingView = editingView else {
                return
            }
            createEditingHelper(for: editingView)
            
            guard let view = editingView as? UITextView else {

               textEditView.isHidden = true
               imageEditContainerView.isHidden = false
                
               return

            }

            view.delegate = self
            
//            self.changeTextAttributeWith(lineHeight: 1.4, letterSpacing: 0.0)

            textEditView.isHidden = false
            imageEditContainerView.isHidden = true
        }
    }

    let fusuma = FusumaViewController()
    var tableViewIndex: Int = 0
    var originalText = ""

    @IBOutlet weak var designView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        fontTableView.al_registerCellWithNib(identifier: String(describing: FontTableViewCell.self), bundle: nil)
        fontTableView.al_registerCellWithNib(identifier: String(describing: SpacingTableViewCell.self), bundle: nil)
        fontTableView.al_registerCellWithNib(identifier: String(describing: FontSizeTableViewCell.self), bundle: nil)
        
        setupImagePicker()
        createNotification()
        selectFontView.isHidden = true

    }

    @IBAction func addBtnTapped(_ sender: Any) {

//        editingView?.layer.borderWidth = 0
        
        let oldHelperView =  designView.subviews.first
        oldHelperView?.removeFromSuperview()
        
        /*Notification*/
        let notificationName = Notification.Name(NotiName.addingMode.rawValue)
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.addingMode: true])

        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func fontButtonTapped(_ sender: Any) {

        tableViewIndex = 0

        fontTableView.isScrollEnabled = true
        fontTableView.reloadData()
        selectFontView.isHidden = false

    }

    @IBAction func colorButtonTapped(_ sender: Any) {
        fontTableView.reloadData()
        selectFontView.isHidden = false
    }
    @IBAction func fontSizeButtonTapped(_ sender: Any) {

        tableViewIndex = 2
        fontTableView.reloadData()
        selectFontView.isHidden = false

    }

    @IBAction func alignmentButtonTapped(_ sender: Any) {

        guard let view =  editingView as? UITextView else { return }

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

    @IBAction func boldButtonTapped(_ sender: Any) {

        guard let view =  editingView as? UITextView else { return }

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

        guard let view =  editingView as? UITextView else { return }

//        view.font = UIFont.preferredFont(forTextStyle: .body).italic()
//        view.adjustsFontForContentSizeCategory = true
//
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

        guard let view =  editingView as? UITextView else { return }

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

        guard designView.subviews.count > 0 else { return }

        for count in 0...designView.subviews.count-1 {
            
            if designView.subviews[count] != helperView {
                addTapGesture(to: designView.subviews[count])
            }
            
        }

    }
}

//Setup Navigation Bar
extension EditingViewController {

    func navigationBarForText() {

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
        self.navigationItem.leftBarButtonItem  = leftButton

    }

    func navigationBarForImage() {
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

    @objc func didTapDoneButton(sender: AnyObject) {

//        editingView?.layer.borderWidth = 0
        
        helperView.removeFromSuperview()
        
        /*Notification*/
        let notificationName = Notification.Name(NotiName.updateImage.rawValue)
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: [NotificationInfo.editedImage: designView.subviews])

        self.navigationController?.popViewController(animated: true)

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
        
        self.navigationController?.popViewController(animated: true)

    }

    @objc func didTapDownButton(sender: AnyObject) {

        guard let editingView = editingView else { return }
        designView.sendSubviewToBack(editingView)

    }

    @objc func didTapUpButton(sender: AnyObject) {

        guard let editingView = editingView else { return }
        designView.bringSubviewToFront(editingView)

    }

    @objc func didTapCopyButton(sender: AnyObject) {

        guard let tappedView = (editingView as? UITextView) else {

            guard let tappedView = (editingView as? UIImageView)else { return }

            let newView = UIImageView()

            newView.makeACopy(from: tappedView)

            addTapGesture(to: newView)
            editingView = newView

            designView.addSubview(newView)

            return
        }

        let newView = UITextView()

        newView.makeACopy(from: tappedView)

        addTapGesture(to: newView)
        editingView = newView

        designView.addSubview(newView)

        editingView = newView
    }
}

//Setup Gesture
extension EditingViewController {
    
    func addAllGesture(to helperView: UIView) {
        
        //Enable label to rotate
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(sender:)))
        helperView.addGestureRecognizer(rotate)
        
        //Enable to move label
        let move = UIPanGestureRecognizer(target: self, action: #selector(handleDragged(_ :)))
        helperView.addGestureRecognizer(move)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
        helperView.addGestureRecognizer(pinch)
    }

    func addTapGesture(to newView: UIView) {

            newView.isUserInteractionEnabled = true

            //Handle to tapped
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            newView.addGestureRecognizer(tap)
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        helperView.removeFromSuperview()

        editingView = sender.view

        guard (sender.view as? UITextView) != nil else {

            guard (sender.view as? UIImageView) != nil else { return }

            navigationBarForImage()

            return
        }

        navigationBarForText()

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
            let center = sender.view!.convert(editingFrame.center, to: designView)
            
            //Make editingView's center equal to editingFrame's center
            editingView?.center = center
            editingView?.transform = rotateValue
            
            //Get the center of editingFrame from helperView to designView
//            let frame = sender.view?.convert(editingFrame.frame, to: designView)
//            editingView?.frame = frame!
            
            print(editingFrame.transform)
            
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
            
//            editingView?.bounds.size = editingFrame.bounds.applying(transform).size
            
            sender.view?.transform = transform
            
            //Get the center of editingFrame from helperView to designView
//            let frame = sender.view?.convert(editingFrame.frame, to: designView)
            
            //Make editingView's center equal to editingFrame's center
         
//            print(editingView?.frame.size)
            
            let center = sender.view?.convert(editingFrame.center, to: designView)
            editingView?.center = center!
            editingView?.transform = transform

//            editingView?.transform = transform
            
            sender.scale = 1
            
            return
        }
    }

    @objc func handleDragged( _ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.view)

        guard let xCenter = editingView?.center.x, let yCenter = editingView?.center.y else { return }

        editingView?.center = CGPoint(x: xCenter+translation.x, y: yCenter+translation.y)
        gesture.setTranslation(CGPoint.zero, in: editingView)

        let view = gesture.view
        guard let xCenter2 = view?.center.x, let yCenter2 = view?.center.y else { return }

        view?.center = CGPoint(x: xCenter2+translation.x, y: yCenter2+translation.y)
        gesture.setTranslation(CGPoint.zero, in: view)

    }
}

extension EditingViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        
        let contentSize = textView.sizeThatFits(textView.bounds.size)
        textView.frame.size.height = contentSize.height

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

    }
}

extension EditingViewController: UITableViewDelegate, UITableViewDataSource,
            SpacingTableViewCellDelegate, FontSizeTableViewCellDelegate {

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

            guard let view = editingView as? UITextView else { return cell }
            guard let fontSize = view.font?.pointSize else {return cell}

            fontSizeCell.delegate = self

            fontSizeCell.fontSizeLabel.text = "\(Int(fontSize))"
            return fontSizeCell

        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch tableViewIndex {
        case 0:
            guard let view = editingView as? UITextView,
                let fontSize = view.font?.pointSize else { return }

            let fontName = FontName.allCases[indexPath.row].rawValue

            guard let newFont = UIFont(name: fontName, size: fontSize) else {
                return
            }

            view.font = newFont

            currentFontName = FontName.allCases[indexPath.row]

            currentFontBtn.setTitle(fontName, for: .normal)
            currentFontBtn.titleLabel?.font = UIFont(name: fontName, size: 20)

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

        guard let view = editingView as? UITextView,
            let fontName = view.font?.fontName,
            let fontSize = view.font?.pointSize  else { return }
        
        let contentSize = view.sizeThatFits(self.view.bounds.size)
        view.frame.size.height = contentSize.height
        
        view.keepAttributeWith(lineHeight: lineHeight,
                               letterSpacing: letterSpacing,
                               fontName: fontName,
                               fontSize: fontSize)
    }

    func changeFontSize(to size: Int) {

        guard let view = editingView as? UITextView, let fontName = view.font?.fontName  else { return }

        let contentSize = view.sizeThatFits(self.view.bounds.size)
        
        view.keepAttributeWith(lineHeight: self.lineHeight,
                               letterSpacing: self.letterSpacing,
                               fontName: fontName,
                               fontSize: CGFloat(size))

        view.font = UIFont(name: fontName, size: CGFloat(size))

        view.frame.size.height = contentSize.height
        
        fontSizeBtn.setTitle(String(size), for: .normal)
    }
}

extension EditingViewController: FusumaDelegate {
    
    //Notification for image picked
    func createNotification() {
        
        // 註冊addObserver
        let notificationName = Notification.Name(NotiName.changeImage.rawValue)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeImage(noti:)), name: notificationName, object: nil)
    }
    
    // 收到通知後要執行的動作
    @objc func changeImage(noti: Notification) {
        if let userInfo = noti.userInfo,
            let mode = userInfo[NotificationInfo.changeImage] as? Bool {
            
            if mode == true {
                self.present(fusuma, animated: true, completion: nil)
            }
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
        
        self.present(fusuma, animated: true, completion: nil)
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
    func fusumaDismissedWithImage(image: UIImage, source: FusumaMode) {
       
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
        
        helperView.backgroundColor = UIColor.clear

        editingFrame.layer.borderWidth = 2
        editingFrame.layer.borderColor = UIColor.white.cgColor

        positionHelper.image = #imageLiteral(resourceName: "noun_navigate")
        rotateHelper.image = #imageLiteral(resourceName: "Icon_Rotate")
//        positionHelper.contentMode = .center
        positionHelper.backgroundColor = UIColor.white
        positionHelper.layer.cornerRadius = 10
        rotateHelper.backgroundColor = UIColor.white
        rotateHelper.layer.cornerRadius = 10
        
        guard let transform = editingView?.transform else { return }
        helperView.transform = transform
        
        helperView.addSubview(rotateHelper)
        helperView.addSubview(positionHelper)
        helperView.addSubview(editingFrame)
        
        designView.addSubview(helperView)
    
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(sender:)))
        rotateHelper.addGestureRecognizer(rotate)
        
        addAllGesture(to: helperView)
       
        guard let xPosition = editingView?.frame.origin.x,
            let yPosition = editingView?.frame.origin.y,
            let width = editingView?.frame.width,
            let height = editingView?.frame.height else { return }
        helperView.frame = CGRect(x: xPosition,
                                  y: yPosition,
                                  width: width+50,
                                  height: height+50)
        
        helperView.backgroundColor = UIColor.blue
        helperView.alpha = 0.4
        
         //Get the frame of editingView from designView to helperView
        let rect = designView.convert(editingView!.frame, to: helperView)
        
        //Make editingFrame's frame equal to editingView's frame
        editingFrame.frame = rect
        
        rotateHelper.translatesAutoresizingMaskIntoConstraints = false
        positionHelper.translatesAutoresizingMaskIntoConstraints = false
    
        rotateHelper.centerXAnchor.constraint(equalTo: (editingFrame.centerXAnchor)).isActive = true
        rotateHelper.topAnchor.constraint(equalTo: (editingFrame.bottomAnchor), constant: 10).isActive = true
        rotateHelper.widthAnchor.constraint(equalToConstant: 20)
        rotateHelper.heightAnchor.constraint(equalToConstant: 20)

        positionHelper.centerYAnchor.constraint(equalTo: (editingFrame.centerYAnchor)).isActive = true
        positionHelper.leadingAnchor.constraint(equalTo: (editingFrame.trailingAnchor), constant: 10).isActive = true
        positionHelper.widthAnchor.constraint(equalToConstant: 20)
        positionHelper.heightAnchor.constraint(equalToConstant: 20)
        
        helperView.layoutIfNeeded()
        editingView?.layoutIfNeeded()
        rotateHelper.layoutIfNeeded()
        positionHelper.layoutIfNeeded()
   
    }
}

