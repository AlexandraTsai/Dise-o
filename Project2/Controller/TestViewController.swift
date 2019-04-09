//
//  TestViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/9.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit
import Fusuma

class TestViewController: UIViewController, FusumaDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.availableModes = [FusumaMode.library, FusumaMode.camera, FusumaMode.video] // Add .video capturing mode to the default .library and .camera modes
        fusuma.cropHeightRatio = 0.6 // Height-to-width ratio. The default value is 1, which means a squared-size photo.
        fusuma.allowMultipleSelection = true // You can select multiple photos from the camera roll. The default value is false.
        self.present(fusuma, animated: true, completion: nil)
    }
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        print("Image selected")
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
        
    }
    
    // Return an image and the detailed information.
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
