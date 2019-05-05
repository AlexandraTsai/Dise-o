//
//  BaseViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/4.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

protocol BaseViewControllerDelegate: AnyObject {
    
    func showAllFilter(for image: UIImage)
    
    func editImageMode()
    
    func editShapeMode()
    
    func noImageMode()
}

extension BaseViewControllerDelegate {
    
    func editShapeMode() {
        
    }
    
    func noImageMode() {
        
    }
    
}

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
}
