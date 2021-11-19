//
//  PhotoLibraryViewController.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/11/10.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import Foundation
import Photos
import PhotosUI
import UIKit
import RxSwift
import SnapKit

class PhotoLibraryViewController: UIViewController {
    init(viewModel: PhotoLibraryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        // To be notified of changes to the photo library,
        PHPhotoLibrary.shared().register(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if PhotoAuthManager.authedPhotoLibrary {
            reloadAssets()
        } else {
            showAccessAlert()
        }
        binding()
    }
    private let limitedAccessView = UIView() --> {
        $0.backgroundColor = UIColor(hex: "#F4F4F4")
    }
    private let itemWidth = Int(screenSize.width) / LCT.itemsPerRow - 2 * 2
    private lazy var flowLayout = UICollectionViewFlowLayout() --> {
        $0.itemSize = CGSize(width: itemWidth, height: itemWidth)
        $0.minimumLineSpacing = 2
        $0.minimumInteritemSpacing = 2
        $0.scrollDirection = .vertical
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout) --> {
        $0.register(AssetImageCollectionViewCell.self, forCellWithReuseIdentifier: AssetImageCollectionViewCell.nameOfClass)
        $0.backgroundColor = .white
        $0.allowsMultipleSelection = true
    }
    private var assets: PHFetchResult<AnyObject>?
    private let requestOptions = PHImageRequestOptions() --> {
        $0.isNetworkAccessAllowed = true
        $0.deliveryMode = .highQualityFormat
        $0.isSynchronous = true
    }
    private var limitAccessViewHeight: Constraint?
    private let viewModel: PhotoLibraryViewModelProtocol
    private let disposeBag = DisposeBag()
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PhotoLibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assets?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: AssetImageCollectionViewCell.nameOfClass, for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let asset = assets?[indexPath.row] as? PHAsset else {
            return
        }
        let isSelected = viewModel.isSelected(asset)
        if isSelected {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        }
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: itemWidth, height: itemWidth),
            contentMode: .aspectFill,
            options: requestOptions) { (image: UIImage?, _) -> Void in
            guard let assetCell = cell as? AssetImageCollectionViewCell,
                let image = image else {
                    return
            }
            assetCell.config(image: image)
        }
    }
}

// MARK: - PHPhotoLibraryChangeObserver
extension PhotoLibraryViewController: PHPhotoLibraryChangeObserver {
    // It is used when the permission changed, for iOS 14
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            // Obtain authorization status and update UI accordingly
            if #available(iOS 14, *) {
                let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
                self.showUI(for: status)
            } else {
                self.reloadAssets()
            }
        }
    }
}

// MARK: - Setup UI
private extension PhotoLibraryViewController {
    func setupUI() {
        setupNav()
        view.addSubview(limitedAccessView)
        limitedAccessView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            limitAccessViewHeight = $0.height.equalTo(0).constraint
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(limitedAccessView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self

        setupLimitedAccessView()

        if #available(iOS 14, *),
           PHPhotoLibrary.authorizationStatus(for: .readWrite) == .limited {
            limitAccessViewHeight?.isActive = false
        } else {
            limitAccessViewHeight?.isActive = true
        }
    }

    func setupNav() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapAddButton))
    }

    func setupLimitedAccessView() {
        let warnLabel = UILabel()
        warnLabel.font = .fontMedium(ofSize: 13)
        warnLabel.textColor = UIColor(hex: "#5C5C5C")
        warnLabel.text = "You’ve allowed access to select photos. You can add more or allow access to all photos"
        warnLabel.numberOfLines = 0

        let manageAccessBtn = UIButton()
        manageAccessBtn.setTitle("Manage", for: .normal)
        manageAccessBtn.setTitleColor(UIColor(hex: "#008DFF"), for: .normal)
        manageAccessBtn.titleLabel?.font = UIFont.fontMedium(ofSize: 14)

        limitedAccessView.addSubview(warnLabel)
        warnLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(16)
        }
        limitedAccessView.addSubview(manageAccessBtn)
        manageAccessBtn.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.left.equalTo(warnLabel.snp.right).offset(8)
            $0.top.bottom.equalTo(warnLabel)
        }
        manageAccessBtn.setContentCompressionResistancePriority(.init(rawValue: 752), for: .horizontal)
        manageAccessBtn.addTarget(self, action: #selector(didTapManageAccessButton), for: .touchUpInside)
    }

    func reloadAssets() {
        collectionView.isHidden = false
        assets = nil
        collectionView.reloadData()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        assets = PHAsset.fetchAssets(with: fetchOptions) as? PHFetchResult<AnyObject>
        collectionView.reloadData()
    }

    func showUI(for status: PHAuthorizationStatus) {
        switch status {
        case .authorized, .limited:
            reloadAssets()
        default:
            dismiss(animated: true)
        }
    }
}

// MARK: - UI Actions
private extension PhotoLibraryViewController {
    @objc
    func didTapAddButton() {
        viewModel.onAdd()
        dismiss(animated: true)
    }

    @objc
    func didTapCancelButton() {
        dismiss(animated: true)
    }

    @objc
    func didTapManageAccessButton() {
        guard #available(iOS 14, *) else {
            return
        }
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
    }

    func showAccessAlert() {
        let alert = UIAlertController(title: "Diseno needs access to your photos",
                                      message: "Please visit Settings > Privacy > Photos > Diseno. Under ALLOW PHOTOS ACCESS, select Read and Write.",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK",
                                         style: UIAlertAction.Style.cancel,
                                         handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

// MARK: - Binding
private extension PhotoLibraryViewController {
    func binding() {
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self,
                      let asset = self.assets?[indexPath.row] as? PHAsset,
                      !self.viewModel.isSelected(asset) else {
                    return
                }
                self.viewModel.add(asset: asset)
            }).disposed(by: disposeBag)

        collectionView.rx.itemDeselected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self,
                      let asset = self.assets?[indexPath.row] as? PHAsset,
                      self.viewModel.isSelected(asset) else {
                    return
                }
                self.viewModel.remove(asset: asset)
            }).disposed(by: disposeBag)
    }
}

private typealias LCT = LocalConstants

private enum LocalConstants {
    static let itemsPerRow = 3
}
