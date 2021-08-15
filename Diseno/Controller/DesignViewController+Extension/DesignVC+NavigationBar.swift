//
//  DesignVC+NavigationBar.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/13.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit
import Photos

extension DesignViewController {
    func setupNavigationBar() {
        //Right Buttons
        let button1 = UIBarButtonItem(
            image: UIImage(named: ImageAsset.Icon_Share.rawValue),
            style: .plain,
            target: self,
            action: #selector(didTapShareButton(sender:)))
        
        let button2 = UIBarButtonItem(
            image: UIImage(named: ImageAsset.Icon_Download.rawValue),
            style: .plain,
            target: self,
            action: #selector(didTapDownloadButton(sender:)))
        
        self.navigationItem.rightBarButtonItems  = [button1, button2]
        
        //Left Buttons
        let leftButton = UIBarButtonItem(
            image: UIImage(named: ImageAsset.Icon_HomePage.rawValue),
            style: .plain,
            target: self,
            action: #selector(tapHomeBtn(sender:)))
        self.navigationItem.leftBarButtonItem  = leftButton
    }
    
    // swiftlint:disable cyclomatic_complexity
    @objc func tapHomeBtn(sender: AnyObject) {
        if designView.subviews.count > 0 {
            prepareForSaving()
        }
        viewModel?.saveDesign(designView)
    }
    // swiftlint:enable cyclomatic_complexity
    
    @objc func didTapShareButton(sender: AnyObject) {
        
        let screenshot = designView.takeScreenshot()
        
        let imageToShare = [ screenshot ]
        
        let activityController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        
        activityController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityController, animated: true, completion: nil)
        
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
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
            
        case PHAuthorizationStatus.authorized, PHAuthorizationStatus.notDetermined:
            
            UIImageWriteToSavedPhotosAlbum(imageWithLabel,
                                           self,
                                           #selector(image(_: didFinishSavingWithError:contextInfo:)),
                                           nil)
            
        default:
            
            saveImageAlert.alpha = 1
            saveImageAlert.addOn(self.view)
            
        }
        
    }
}
