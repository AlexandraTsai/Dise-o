//
//  PhotoAuthManager.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/11/10.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import Foundation
import Photos

enum PhotoAuthManager {
    static var authedCamera: Bool {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .authorized, .notDetermined:
            return true
        default:
            return false
        }
    }

    static var authedPhotoLibrary: Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .notDetermined:
            return true
        default:
            return false
        }
    }
}
