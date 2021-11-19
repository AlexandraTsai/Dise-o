//
//  AssetImageCollectionViewCell.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/11/11.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit

class AssetImageCollectionViewCell: UICollectionViewCell {
    func config(image: UIImage) {
        imageView.image = image
    }

    // Internal
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
    }

    override var isSelected: Bool {
        didSet {
            isSelectedMask.isHidden = !isSelected
        }
    }

    private let isSelectedMask = UIView() --> {
        $0.backgroundColor = .white.withAlphaComponent(0.5)
        $0.isHidden = true
    }
    private let imageView = UIImageView()
}

// MARK: - UI Setup
private extension AssetImageCollectionViewCell {
    func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.addSubview(isSelectedMask)
        isSelectedMask.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        setupMask()
    }

    /// Setup the mask for the selected style
    func setupMask() {
        let checkIcon = UIImageView()
        checkIcon.image = UIImage.init(imageLiteralResourceName: "check").tinted(color: .white)
        checkIcon.backgroundColor = .systemBlue
        checkIcon.layer.cornerRadius = 10
        isSelectedMask.addSubview(checkIcon)
        checkIcon.snp.makeConstraints {
            $0.bottom.right.equalToSuperview().inset(5)
            $0.height.width.equalTo(20)
        }
    }
}
