//
//  EditingVC+ImageShapeEdit.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/13.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

extension EditingViewController {
    
    func createEditingHelper(for view: UIView) {
        
        helperView = HelperView()
        
        designView.addSubview(helperView)
        
        guard let editingView = editingView else { return }
        
        helperView.resize(accordingTo: editingView)
        
        //Handle to tapped
        addAllGesture(to: helperView)
        helperView.positionHelperAddGesture(target: self, action: #selector(handleDragged(_:)))
        helperView.rotateHelperAddGesture(target: self, action: #selector(handleCircleGesture(sender:)))
        helperView.sizeHelperAddGesture(target: self, action: #selector(handleSizeHelper(sender:)))
        helperView.cornerHelperAddGesture(target: self, action: #selector(handleCornerResize(gesture:)))
        
        if editingView is UIImageView {
            
            helperView.withoutResizeHelper()
            
        } else if editingView is UITextView {
            
            helperView.withWidthHelper()
            
        } else if editingView is UITextView {
            
            helperView.withResizeHelper()
            
        }
        
    }
    
    func changeEditingMode() {
        
        if let textView = editingView as? ALTextView {
            
            editTextMode()
            
            textView.delegate = self
            
            guard let alpha = textView.textColor?.cgColor.alpha,
                let font = textView.font,
                let color = textView.textColor else { return }
            
            textContainerVC?.setupAllTool(alignment: textView.textAlignment,
                                          font: font,
                                          upperCase: textView.upperCase,
                                          alpha: alpha,
                                          textColor: color)
            
        } else if let view = editingView as? ALShapeView {
            
            editNonTextMode()
            
            let alpha = view.alpha
            
            imageContainerVC?.setupAllTool(with: alpha, forImage: false)
            
        } else if let view = editingView as? ALImageView {
            
            editNonTextMode()
            
            imageContainerVC?.editImageMode()
            
            let alpha = view.alpha
            
            imageContainerVC?.setupAllTool(with: alpha, forImage: true)
            
            if let image = view.originImage {
                
                delegate?.showAllFilter(for: image)
            }
            
        }
        
    }
    
    func editTextMode() {
        
        imageEditContainerView.isHidden = true
        textEditContainterView.isHidden = false
        
    }
    
    func editNonTextMode() {
        
        textEditContainterView.isHidden = true
        imageEditContainerView.isHidden = false
        
    }
    
}
