//
//  PhotoLibraryViewModel.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/11/11.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import Foundation
import Photos
import UIKit

protocol PhotoLibraryViewModelInput {
    func isSelected(_ asset: PHAsset) -> Bool
    func add(asset: PHAsset)
    func remove(asset: PHAsset)
    func onAdd()
}
protocol PhotoLibraryViewModelOutput {}

protocol PhotoLibrarySelectHandler: AnyObject {
    func addImages(_ images: [UIImage])
}

typealias PhotoLibraryViewModelProtocol = PhotoLibraryViewModelInput & PhotoLibraryViewModelOutput

class PhotoLibraryViewModel: PhotoLibraryViewModelProtocol {
    func isSelected(_ asset: PHAsset) -> Bool {
        selected.contains(asset)
    }

    func add(asset: PHAsset) {
        selected.append(asset)
    }

    func remove(asset: PHAsset) {
        guard let index = selected.firstIndex(where: { $0 == asset }) else {
            return
        }
        selected.remove(at: index)
    }

    func onAdd() {
        parent?.addImages(selected.compactMap { $0.getUIImage() })
    }

    init(parent: PhotoLibrarySelectHandler) {
        self.parent = parent
    }

    private var selected: [PHAsset] = []
    private weak var parent: PhotoLibrarySelectHandler?
}

private extension PHAsset {
    func getUIImage() -> UIImage? {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.isNetworkAccessAllowed = true
        manager.requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { image, _ in
            img = image
        }
        return img
    }
}
