//
//  ImageEditContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/7.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit
import HueKit
import Photos

protocol ImageEditContainerVCDelegate: AnyObject {
    
    func changeEditingViewColor(with color: UIColor)
    func transparencyChange(to alpha: CGFloat)
    
}

class ImageEditContainerViewController: BaseContainerViewController {
    
    weak var editingDelegate: ImageEditContainerVCDelegate?

    @IBOutlet weak var transparencyUnderLine: UIView!

    @IBOutlet weak var transparencyBtn: UIButton! {
        
        didSet {
            
            transparencyBtn.setImage(ImageAsset.Icon_transparency.imageTemplate, for: .normal)
            transparencyBtn.tintColor = UIColor.DSColor.lightGreen
            
        }
        
    }
    
    @IBOutlet weak var paletteView: UIView!
    @IBOutlet weak var defaultColorView: UIView!
    @IBOutlet weak var transparencyView: UIView!
    
    @IBOutlet weak var usedColorButton: UIButton!
    
    @IBOutlet weak var slider: UISlider!

    @IBOutlet weak var transparencyLabel: UILabel!
    
    @IBOutlet weak var whiteColorButton: UIButton! {
        
        didSet {
            
            whiteColorButton.layer.borderWidth = 1
            whiteColorButton.layer.borderColor = UIColor.DSColor.lightGray.cgColor
            
        }
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        slider.addTarget(self, action: #selector(changeTransparency(_:)), for: .valueChanged)
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

        filterCollectionView.al_registerCellWithNib(identifier: String(describing: FilterCollectionViewCell.self),
                                                    bundle: nil)
        
    }
    
    @IBAction func cameraRollBtnTapped(_ sender: Any) {
        
        cameraRollButton.tintColor = UIColor.DSColor.heavyGreen
        colorButton.tintColor = UIColor.DSColor.lightGreen
        transparencyBtn.tintColor = UIColor.DSColor.lightGreen
        filterView.tintColor = UIColor.DSColor.lightGreen
        
        photoView.isHidden = false
        transparencyView.isHidden = true
        filterView.isHidden = true
        defaultColorView.isHidden = true
        paletteView.isHidden = true

        cameraUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        transparencyUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        filterUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
    }
    
    @IBAction func colorsBtnTapped(_ sender: Any) {
        
        cameraRollButton.tintColor = UIColor.DSColor.lightGreen
        colorButton.tintColor = UIColor.DSColor.heavyGreen
        transparencyBtn.tintColor = UIColor.DSColor.lightGreen
        filterButton.tintColor = UIColor.DSColor.lightGreen
        
        cameraUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        transparencyUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        filterUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
        transparencyView.isHidden = true
        photoView.isHidden = true
        filterView.isHidden = true
        defaultColorView.isHidden = false
        
    }
    
    @IBAction func filterBtnTapped(_ sender: Any) {
        
        filterView.isHidden = false
        
        cameraRollButton.tintColor = UIColor.DSColor.lightGreen
        colorButton.tintColor = UIColor.DSColor.lightGreen
        transparencyBtn.tintColor = UIColor.DSColor.lightGreen
        filterButton.tintColor = UIColor.DSColor.heavyGreen
        
        cameraUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        transparencyUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        filterUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        
        transparencyView.isHidden = true
        photoView.isHidden = true
        filterView.isHidden = false
        defaultColorView.isHidden = true
        paletteView.isHidden = true
        
    }

    @IBAction func transparencyBtnTapped(_ sender: Any) {

        cameraRollButton.tintColor = UIColor.DSColor.lightGreen
        colorButton.tintColor = UIColor.DSColor.lightGreen
        transparencyBtn.tintColor = UIColor.DSColor.heavyGreen
        
        cameraUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        transparencyUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        filterUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
        transparencyView.isHidden = false
        photoView.isHidden = true
        filterView.isHidden = true
        defaultColorView.isHidden = true
        paletteView.isHidden = true
    }
    
    @IBAction func photoLibraryBtnTapped(_ sender: UIButton) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
            
        case PHAuthorizationStatus.authorized:
            
            delegate?.pickImageWithAlbum()
        case PHAuthorizationStatus.notDetermined:
            
            PHPhotoLibrary.requestAuthorization({ [weak self] status in
                
                if status == .authorized {
                    
                    self?.delegate?.pickImageWithAlbum()
               }
                
            })
            
        default:
            
            delegate?.showPhotoLibrayAlert()
        
        }
      
    }
    
    @IBAction func cameraBtnTapped(_ sender: UIButton) {
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch status {
            
        case AVAuthorizationStatus.authorized:
            
           delegate?.pickImageWithCamera()

        case AVAuthorizationStatus.notDetermined:
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] granted in
                
                if granted {
                    
                    self?.delegate?.pickImageWithCamera()

                }
                
            }
            
        default:
            delegate?.showCameraAlert()
        }
        
    }
    
    @IBAction func usedColorBtnTapped(_ sender: Any) {
        
        paletteView.isHidden = false
        defaultColorView.isHidden = true
        
    }
    
    @IBAction func defaultColorBtnTapped(_ sender: UIButton) {
        
        guard let color = sender.backgroundColor else { return }
        
        editingDelegate?.changeEditingViewColor(with: color)
   
    }
    
    @IBAction func colorBarPickerValueChanged(_ sender: ColorBarPicker) {
        
        colorSquarePicker.hue = sender.hue
        
        editingDelegate?.changeEditingViewColor(with: colorSquarePicker.color)

    }
    
    @IBAction func colorSquarePickerValueChanged(_ sender: ColorSquarePicker) {
       
        delegate?.changeColor(to: sender.color)

    }
    
    @IBAction func checkBtnTapped(_ sender: Any) {
        
        paletteView.isHidden = true
        
        defaultColorView.isHidden = false

    }
    
    @IBAction func sliderDidSlide(_ sender: UISlider) {
        
        transparencyLabel.text = "\(Int(sender.value))"
        
    }
    
    override func editImageMode() {
        
        super.editImageMode()
        
        filterView.isHidden = false
        
        photoView.isHidden = true
        transparencyView.isHidden = true
        defaultColorView.isHidden = true
        paletteView.isHidden = true
        
        cameraRollButton.isHidden = false
        cameraUnderLine.isHidden = false
        filterButton.isHidden = false
        filterUnderLine.isHidden = false
        
        cameraRollButton.tintColor = UIColor.DSColor.lightGreen
        cameraUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        colorButton.tintColor = UIColor.DSColor.lightGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        transparencyBtn.tintColor = UIColor.DSColor.lightGreen
        transparencyUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
        filterButton.tintColor = UIColor.DSColor.heavyGreen
        filterUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        
    }
    
    override func editShapeMode() {
        
        photoView.isHidden = true
        filterView.isHidden = true
        transparencyView.isHidden = true
        defaultColorView.isHidden = false
        paletteView.isHidden = true
        
        cameraRollButton.isHidden = true
        cameraUnderLine.isHidden = true
        filterButton.isHidden = true
        filterUnderLine.isHidden = true
        
        colorButton.tintColor = UIColor.DSColor.heavyGreen
        colorUnderLine.backgroundColor = UIColor.DSColor.heavyGreen
        
        transparencyBtn.tintColor = UIColor.DSColor.lightGreen
        transparencyUnderLine.backgroundColor = UIColor.DSColor.lightGreen
        
    }
   
}

extension ImageEditContainerViewController {
    
    func setupAllTool(with alpha: CGFloat, forImage: Bool) {
        
        slider.value = Float(alpha*100)
        
        transparencyLabel.text = "\(Int(Float(alpha*100)))"
        
        if forImage { editImageMode() } else { editShapeMode() }
        
    }
    
    @objc func changeTransparency(_ sender: UISlider) {
    
        editingDelegate?.transparencyChange(to: CGFloat(sender.value/100))

    }
}
