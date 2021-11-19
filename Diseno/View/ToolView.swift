//
//  ToolView.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/10/30.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol ToolViewDelegate: AnyObject {
    func didSelect(tool: PlusMenuType)
    func close(_ toolView: ToolView)
}

class ToolView: UIView {
    weak var delegate: ToolViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let closeBtn = UIButton() --> {
        $0.setImage(#imageLiteral(resourceName: "cancel")
                        .withRenderingMode(.alwaysTemplate),
                    for: .normal)
        $0.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        $0.tintColor = .white
    }
    lazy var container: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.register(ToolCollectionViewCell.self, forCellWithReuseIdentifier: ToolCollectionViewCell.nameOfClass)
        cv.contentInset = .init(top: 20, left: 0, bottom: 20, right: 0)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    private let flowLayout = UICollectionViewFlowLayout() --> {
        $0.itemSize = .init(width: 32, height: 32)
        $0.minimumInteritemSpacing = 75
        $0.minimumLineSpacing = 75
        $0.scrollDirection = .horizontal
    }
    private let disposeBag = DisposeBag()
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ToolView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        PlusMenuType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToolCollectionViewCell.nameOfClass,
                                                            for: indexPath) as? ToolCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.config(image: PlusMenuType.allCases[indexPath.row].image)
        return cell
    }
}

extension ToolView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(tool: PlusMenuType.allCases[indexPath.row])
    }
}

// MARK: - UI Setup
private extension ToolView {
    func setupUI() {
        backgroundColor = UIColor.Primary.highLight
        addSubview(container)
        addSubview(closeBtn)
        container.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalTo(closeBtn.snp.left).offset(-20)
            $0.left.equalToSuperview().offset(30)
            $0.height.equalTo(70)
            $0.bottom.lessThanOrEqualToSuperview()
        }
        closeBtn.snp.makeConstraints {
            $0.height.width.equalTo(30)
            $0.right.equalToSuperview().inset(Constant.padding)
            $0.centerY.equalTo(container)
        }
        container.delegate = self
        container.dataSource = self
    }
}

// MARK: - UI Actions
private extension ToolView {
    func setupGesture() {
        closeBtn.addTarget(self, action: #selector(onClose), for: .touchUpInside)
    }

    @objc func onClose() {
        delegate?.close(self)
    }

    @objc
    func addImageDidTapped() {}
}
