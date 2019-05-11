//
//  BaseViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/4.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit
import Fusuma

protocol BaseViewControllerDelegate: AnyObject {
    
    func showAllFilter(for image: UIImage)
    
    func editImageMode()
    
    func editShapeMode()
    
    func noImageMode()
    
    func pickImageMode()
}

class BaseViewController: UIViewController, FusumaDelegate {    
    
    weak var delegate: BaseViewControllerDelegate?
    
    let fusumaAlbum = FusumaViewController()
    let fusumaCamera = FusumaViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCamera()
        setupImagePicker()
    }
    
    func saveImage(fileName: String, image: UIImage) {
        
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                
                print("Couldn't remove file at path", removeError)
            }
        }
        
        do {
            
            try data.write(to: fileURL)
            print(fileURL)
            
        } catch let error {
            
            print("error saving file with error", error)
            
        }
        
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory,
                                                        userDomainMask,
                                                        true)
        
        if let dirPath = paths.first {
            
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            
            let image = UIImage(contentsOfFile: imageUrl.path)
            
            return image
            
        }
        
        return nil
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
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
    
    func fusumaClosed() {
        
    }
    
    func setupImagePicker() {
        
        fusumaAlbum.delegate = self
        fusumaAlbum.availableModes = [FusumaMode.library]
        
        // FusumaMode.camera
        
        // Add .video capturing mode to the default .library and .camera modes
        fusumaAlbum.cropHeightRatio = 1
        // Height-to-width ratio. The default value is 1, which means a squared-size photo.
        fusumaAlbum.allowMultipleSelection = false
        // You can select multiple photos from the camera roll. The default value is false.
        
        fusumaSavesImage = true
        
        fusumaTitleFont = UIFont(name: FontName.copperplate.boldStyle(), size: 18)
        
        fusumaBackgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        
        fusumaCameraRollTitle = "Camera Roll"
        
        fusumaTintColor = UIColor(red: 244/255, green: 200/255, blue: 88/255, alpha: 1)
        
        fusumaCameraTitle = "Camera"
        fusumaBaseTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
    }
    
    func setupCamera() {
        
        fusumaCamera.delegate = self
        fusumaCamera.availableModes = [FusumaMode.camera]
        
        fusumaSavesImage = true
        
        fusumaTitleFont = UIFont(name: FontName.copperplate.boldStyle(), size: 18)
        
        fusumaBackgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        
        fusumaCameraTitle = "Camera"
        fusumaBaseTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
    }
    
}
  
