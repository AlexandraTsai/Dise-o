//
//  DesignVC+Fusuma.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/13.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

extension DesignViewController: BaseContainerViewControllerDelegate {
    
    func pickImageWithAlbum() {
        
        DispatchQueue.main.async { [weak self, fusumaAlbum] in
        
            self?.present(fusumaAlbum, animated: true, completion: nil)
        }
        
    }
    
    func pickImageWithCamera() {
        
        DispatchQueue.main.async { [weak self, fusumaCamera] in
        
            self?.present(fusumaCamera, animated: true, completion: nil)
        }
        
    }
    
    func showPhotoLibrayAlert() {
        
        openLibraryAlert.alpha = 1
        openLibraryAlert.addOn(self.view)
        openLibraryAlert.titleLabel.text = "To use your own photos, please allow access to your camera roll."
    }
    
    func showCameraAlert() {
        
        openCameraAlert.alpha = 1
        openCameraAlert.addOn(self.view)
        openCameraAlert.titleLabel.text = "To use the Camera, pleace allow permission for Diseño in Settings."
        
    }
    
    func changeImageWith(filter: FilterType?) {
        
        guard let fileName = designView.imageFileName else { return }
        
        let originImage = loadImageFromDiskWith(fileName: fileName)
        
        if let filter = filter {
            
            DispatchQueue.main.async { [weak self] in
                
                self?.designView.image = originImage?.addFilter(filter: filter)
                
            }
            
            designView.filterName = filter
            
        } else {
            
            DispatchQueue.main.async { [weak self] in
                
                self?.designView.image = originImage
            }
            
            designView.filterName = nil
        }
        
    }
    
    func changeSelector() {
        
        if designView.image == nil {
            
            self.delegate?.noImageMode()
            
        } else {
            
            guard let fileName = designView.imageFileName else { return }
            
            guard let image = loadImageFromDiskWith(fileName: fileName) else { return }
            
            self.delegate?.showAllFilter(for: image)
            
            if showFilter {
                
                self.delegate?.editImageMode()
                
            } else {
                
                self.delegate?.pickImageMode()
            }
        }
        
    }
    
    func changeColor(to color: UIColor) {
        
        designView.image = nil
        designView.backgroundColor = color
        
        delegate?.noImageMode()
        
    }
}
