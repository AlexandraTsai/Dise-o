//
//  DesignVC+passData.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/13.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

extension DesignViewController: EditingVCDelegate {
    
    func goToEditingVC(with viewToBeEdit: UIView, navigationBarForImage: Bool) {
        
        guard let editingVC = UIStoryboard(
            name: "Main",
            bundle: nil).instantiateViewController(
                withIdentifier: String(describing: EditingViewController.self)) as? EditingViewController
            else { return }
        
        editingVC.loadViewIfNeeded()
        
        editingVC.finishEditDelegate = self
        editingVC.designView.backgroundColor = designView.backgroundColor
        editingVC.designView.image = designView.image
        
        let count = designView.subviews.count
        
        for _ in 0...count-1 {
            
            guard let subViewToAdd = designView.subviews.first else { return }
            
            editingVC.designView.addSubview(subViewToAdd)
        }
        
        editingVC.setupNavigationBar()
        
        if let imageView = viewToBeEdit as? ALImageView {
            
            if let image = imageView.originImage {
                
                editingVC.delegate?.showAllFilter(for: image)
                editingVC.delegate?.editImageMode()
                
            }
            
        }
        
        editingVC.editingView = viewToBeEdit
        
        show(editingVC, sender: nil)
    }
    
    func finishEdit(with subViews: [UIView]) {
        
        guard subViews.count != 0 else { return }
        
        for count in 0...subViews.count-1 {
            
            designView.addSubview(subViews[count])
            addAllGesture(to: subViews[count])
            
        }
        
        addElementView.isHidden = true
        
        hintView.isHidden = false
        
    }
}
