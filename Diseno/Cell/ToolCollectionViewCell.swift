//
//  ToolCollectionViewCell.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/8/28.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit

class ToolCollectionViewCell: UICollectionViewCell {
    func config(image: UIImage, imageInset: CGFloat? = nil) {
        icon.image = image
        if let imageInset = imageInset {
            icon.snp.updateConstraints {
                $0.edges.equalToSuperview().inset(imageInset)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(icon)
        icon.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private let icon = UIImageView()
}
