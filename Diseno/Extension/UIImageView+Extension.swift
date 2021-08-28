//
//  UIImageView+Extension.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/4.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

extension UIImageView {
    func makeACopy(from originView: UIImageView) {

        //Record the rotaion of the original image view
        let originRotation =  originView.transform

        //Transform the origin image view
        originView.transform = CGAffineTransform(rotationAngle: 0)

        self.frame = originView.frame

        self.transform = originRotation
        self.image = originView.image
        self.alpha = originView.alpha

        originView.transform = originRotation

    }
}

extension UIImage {
    func tinted(color: UIColor) -> UIImage {
        let newImage = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        color.set()
        newImage.draw(in: CGRect(origin: .zero,
                                 size: size))

        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
