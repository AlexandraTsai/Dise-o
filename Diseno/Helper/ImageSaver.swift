//
//  ImageSaver.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/7/31.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit

class ImageSaver: NSObject {
    init(successHandler: @escaping () -> Void,
         failedHandler: @escaping () -> Void) {
        self.successHandler = successHandler
        self.failedHandler = failedHandler
    }

    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image,
                                       self,
                                       #selector(saveError(_:didFinishSavingWithError:contextInfo:)),
                                       nil)
    }

    private let successHandler: () -> Void
    private let failedHandler: () -> Void
}

private extension ImageSaver {
    @objc
    func saveError(_ image: UIImage,
                   didFinishSavingWithError error: Error?,
                   contextInfo: UnsafeRawPointer) {
        if error != nil {
            failedHandler()
        } else {
            successHandler()
        }
    }
}
