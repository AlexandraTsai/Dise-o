//
//  ALTransition.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/4.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class ScaleSegue: UIStoryboardSegue {
    
    override func perform() {
        super.perform()
        
        scale()
    }
    
    func scale() {
        
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            toViewController.view.transform = CGAffineTransform.init(scaleX: 10, y: 10)
        }) { (success) in
            fromViewController.present(toViewController, animated: false, completion: nil)
        }
        
        
    }
}
