//
//  DesignBoardViewController.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/8/28.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DesignBoardViewController: UIViewController {
    init(viewModel: DesignBoardViewModelProtocol?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGesture()
        binding()
    }

    private let designContainerView = UIImageView() --> {
        $0.backgroundColor = .white
    }
    private let plusButton = UIButton() --> {
        $0.backgroundColor = UIColor.Primary.background
        $0.clipsToBounds = true
        $0.setImage(#imageLiteral(resourceName: "Icon_add_button").tinted(color: UIColor.Primary.highLight), for: .normal)
    }
    private let flowLayout = UICollectionViewFlowLayout() --> {
        $0.itemSize = CGSize(width: 50, height: 50)
        $0.minimumLineSpacing = 5
        $0.minimumInteritemSpacing = 5
    }
    private lazy var toolCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout) --> {
        $0.register(ToolCollectionViewCell.self, forCellWithReuseIdentifier: ToolCollectionViewCell.nameOfClass)
        $0.backgroundColor = .clear
    }
    private var onFocusView: UIView? {
        willSet {
            onFocusView?.layer.borderWidth = 0
            onFocusView?.layer.borderColor = nil
        }
        didSet {
            prepareForOnFocusView()
        }
    }
    private weak var viewModel: DesignBoardViewModelProtocol?
    private let disposeBag = DisposeBag()
}

private extension DesignBoardViewController {
    func setupUI() {
        view.backgroundColor = UIColor.Primary.background
        view.addSubview(designContainerView)
        designContainerView.snp.makeConstraints {
            $0.height.equalTo(designContainerView.snp.width)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview().inset(Constant.padding)
        }

        view.addSubview(plusButton)
        plusButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.left.equalToSuperview().inset(Constant.padding)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }

        view.addSubview(toolCollectionView)
        toolCollectionView.snp.makeConstraints {
            $0.left.equalTo(plusButton.snp.right).offset(20)
            $0.right.equalToSuperview().inset(Constant.padding)
            $0.height.centerY.equalTo(plusButton)
        }
    }

    func setupGesture() {
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.onFucus(.none)
                self?.onFocusView = nil
            }).disposed(by: disposeBag)

        designContainerView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.onFucus(.container)
                self?.onFocusView = self?.designContainerView
            }).disposed(by: disposeBag)
    }

    func binding() {
        guard let viewModel = viewModel else { return }
        viewModel.focusType
            .map { $0.tools }
            .bind(to: toolCollectionView.rx.items(cellIdentifier: ToolCollectionViewCell.nameOfClass,
                                                  cellType: ToolCollectionViewCell.self)) { _, tool, cell in
                cell.config(image: tool.icon)
            }
            .disposed(by: disposeBag)
    }

    func prepareForOnFocusView() {
        guard let onFocusView = onFocusView else { return }
        onFocusView.layer.borderWidth = 1
        onFocusView.layer.borderColor = UIColor.Primary.highLight.cgColor
    }
}

class ToolCollectionViewCell: UICollectionViewCell {
    func config(image: UIImage) {
        icon.image = image
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
