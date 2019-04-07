//
//  ImageEditViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/1.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

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
    
    var lineHeight: Float = 0
    var letterSpacing: Float = 0
    var currentFontName: FontName = FontName.alNile
    
    var editingView: UIView? {
        
        didSet {
           
            oldValue?.layer.borderWidth = 0
            
            editingView?.layer.borderColor = UIColor.white.cgColor
            editingView?.layer.borderWidth = 1
            
            guard let view = editingView as? UITextView else { return }
            
            view.delegate = self
            self.changeTextAttributeWith(lineHeight: 1.4, letterSpacing: 0.0)
        }
    }
    
    var tableViewIndex: Int = 0
    var originalText = ""

    @IBOutlet weak var designView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fontTableView.al_registerCellWithNib(identifier: String(describing: FontTableViewCell.self), bundle: nil)
        fontTableView.al_registerCellWithNib(identifier: String(describing: SpacingTableViewCell.self), bundle: nil)
        fontTableView.al_registerCellWithNib(identifier: String(describing: FontSizeTableViewCell.self), bundle: nil)
        
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        
        editingView?.layer.borderWidth = 0
        
        /*Notification*/
        let notificationName = Notification.Name(NotiName.addingMode.rawValue)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: [NotificationInfo.addingMode: true])
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    @IBAction func fontButtonTapped(_ sender: Any) {
        
        tableViewIndex = 0
        fontTableView.isScrollEnabled = true
        fontTableView.reloadData()
        textEditView.isHidden = true
        
    }
    
    @IBAction func colorButtonTapped(_ sender: Any) {
        fontTableView.reloadData()
        textEditView.isHidden = true
    }
    @IBAction func fontSizeButtonTapped(_ sender: Any) {
        
        tableViewIndex = 2
        fontTableView.reloadData()
        textEditView.isHidden = true
        
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
        textEditView.isHidden = false
        
    }
    
    @IBAction func boldButtonTapped(_ sender: Any) {
        
        guard let view =  editingView as? UITextView else { return }

//        view.font = UIFont.preferredFont(forTextStyle: .body).bold()
//        view.adjustsFontForContentSizeCategory = true
     
        switch boldbutton.currentTitleColor {
            
        case UIColor.red:
            
            view.font = UIFont(name: currentFontName.rawValue, size: (view.font?.pointSize)!)
            
            boldbutton.setTitleColor(UIColor.white, for: .normal)
            
        default:
           
            view.font = UIFont(name: currentFontName.boldStyle(), size: (view.font?.pointSize)!)
            
            boldbutton.setTitleColor(UIColor.red, for: .normal)

        }
    
    }
    
    @IBAction func italicButtonTapped(_ sender: Any) {
        
        guard let view =  editingView as? UITextView else { return }
        
        view.font = UIFont.preferredFont(forTextStyle: .body).italic()
        view.adjustsFontForContentSizeCategory = true
        
//        boldbutton.setTitleColor(UIColor.red, for: .normal)
        
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
        
        textEditView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard designView.subviews.count > 0 else { return }
        
        for i in 0...designView.subviews.count-1 {
            addAllGesture(to: designView.subviews[i])
        }
        
    }
}

//Setup Navigation Bar
extension EditingViewController {
    
    func navigationBarForText() {
        
        let button1 = UIBarButtonItem(image: UIImage(named: ImageAsset.Icon_TrashCan.rawValue), style: .plain, target: self, action: #selector(didTapDeleteButton(sender:)))
        
        let button2 = UIBarButtonItem(image: UIImage(named: ImageAsset.Icon_down.rawValue), style: .plain, target: self, action: #selector(didTapDownButton(sender:)))
        
        let button3 = UIBarButtonItem(image: UIImage(named: ImageAsset.Icon_up.rawValue), style: .plain, target: self, action: #selector(didTapUpButton(sender:)))
        
        let button4 = UIBarButtonItem(image: UIImage(named: ImageAsset.Icon_Copy.rawValue), style: .plain, target: self, action: #selector(didTapCopyButton(sender:)))
        
        self.navigationItem.rightBarButtonItems  = [button1, button2, button3, button4]
        
        //Left Buttons
        let leftButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton(sender:)))
        self.navigationItem.leftBarButtonItem  = leftButton
        
    }
    
    func navigationBarForImage() {
        let button1 = UIBarButtonItem(image: UIImage(named: ImageAsset.Icon_Crop.rawValue), style: .plain, target: self, action: #selector(didTapCropButton(sender:)))
        
        let button2 = UIBarButtonItem(image: UIImage(named: ImageAsset.Icon_TrashCan.rawValue), style: .plain, target: self, action: #selector(didTapDeleteButton(sender:)))
        
        let button3 = UIBarButtonItem(image: UIImage(named: ImageAsset.Icon_down.rawValue), style: .plain, target: self, action: #selector(didTapDownButton(sender:)))
        
        let button4 = UIBarButtonItem(image: UIImage(named: ImageAsset.Icon_up.rawValue), style: .plain, target: self, action: #selector(didTapUpButton(sender:)))
        
        let button5 = UIBarButtonItem(image: UIImage(named: ImageAsset.Icon_Copy.rawValue), style: .plain, target: self, action: #selector(didTapCopyButton(sender:)))
        
        self.navigationItem.rightBarButtonItems  = [button1, button2, button3, button4, button5]
        
        //Left Buttons
        let leftButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton(sender:)))
        self.navigationItem.leftBarButtonItem  = leftButton
        
    }
    
    @objc func didTapDoneButton(sender: AnyObject) {
        
        editingView?.layer.borderWidth = 0
        
        /*Notification*/
        let notificationName = Notification.Name(NotiName.updateImage.rawValue)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: [NotificationInfo.editedImage: designView.subviews])

        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func didTapCropButton(sender: AnyObject) {
        
        
    }
    
    @objc func didTapDeleteButton(sender: AnyObject) {
        
        guard let editingView = editingView else{ return }
        editingView.removeFromSuperview()
        
    }
    
    @objc func didTapDownButton(sender: AnyObject) {
        
        guard let editingView = editingView else{ return }
        designView.sendSubviewToBack(editingView)
        
    }
    
    @objc func didTapUpButton(sender: AnyObject) {
        
        guard let editingView = editingView else{ return }
        designView.bringSubviewToFront(editingView)
        
    }
    
    @objc func didTapCopyButton(sender: AnyObject) {
        
        guard let tappedView = (editingView as? UITextView) else {
            
            guard let tappedView = (editingView as? UIImageView)else { return }

            let newView = UIImageView()
            
            newView.makeACopy(from: tappedView)
            
            addAllGesture(to: newView)
            editingView = newView
            
            designView.addSubview(newView)
            
            return
        }
  
        let newView = UITextView()
   
        newView.makeACopy(from: tappedView)
  
        addAllGesture(to: newView)
        editingView = newView
        
        designView.addSubview(newView)
  
        editingView = newView
    }
}

//Setup Gesture
extension EditingViewController {
    
    func addAllGesture(to newView: UIView){
        
            newView.isUserInteractionEnabled = true
            
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
            
           // sender.scale = 1
          
            guard let textView = sender.view as? UITextView else { return }
            
//            var pointSize = textView.font?.pointSize
            //pointSize = ((sender.velocity > 0) ? 1 : -1) * 0.5 + pointSize!
           // textView.font = UIFont( name: "arial", size:
//            textView.textInputView.transform  = transform
            
//            textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!*sender.scale)
            
            textView.updateTextFont()
       
            sender.scale = 1
            
         //   let formattedText = NSMutableAttributedString.init(attributedString: textView.attributedText)
         //   formattedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: pointSize!), range: NSRange(location: 0, length: formattedText.length))
          //  textView.attributedText = formattedText
            
            return
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

extension EditingViewController: UITextViewDelegate{
   
    func textViewDidChange(_ textView: UITextView) {
        
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

extension EditingViewController: UITableViewDelegate, UITableViewDataSource, SpacingTableViewCellDelegate, FontSizeTableViewCellDelegate  {
   
   
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
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FontTableViewCell.self), for: indexPath)
            
            guard let fontCell = cell as? FontTableViewCell else { return cell }
            
            fontCell.fontLabel.text = FontName.allCases[indexPath.row].rawValue
            fontCell.fontLabel.font = UIFont(name: FontName.allCases[indexPath.row].rawValue, size: 18)
            
            return fontCell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SpacingTableViewCell.self), for: indexPath)
            
            guard let spacingCell = cell as? SpacingTableViewCell else { return cell }
            
            spacingCell.delegate = self
            
            return spacingCell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FontSizeTableViewCell.self), for: indexPath)
            
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

        guard let view = editingView as? UITextView, let fontName = view.font?.fontName, let fontSize = view.font?.pointSize  else { return }
        view.keepAttributeWith(lineHeight: lineHeight, letterSpacing: letterSpacing, fontName: fontName, fontSize: fontSize)
    }
    
    func changeFontSize(to size: Int) {
        
        guard let view = editingView as? UITextView, let fontName = view.font?.fontName  else { return }
       
        view.keepAttributeWith(lineHeight: self.lineHeight, letterSpacing: self.letterSpacing, fontName: fontName, fontSize: CGFloat(size))
        
        view.font = UIFont(name: fontName, size: CGFloat(size))

        fontSizeBtn.setTitle(String(size), for: .normal)
    }
}
