//
//  HomePageViewController.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/7/17.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxKeyboard

class HomePageViewController: UIViewController {
    init(viewModel: HomePageViewModelPrototype) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupUI()
        keyboardObserve()
        binding()
    }

    private let flowLayout = UICollectionViewFlowLayout() --> {
        let width = (UIScreen.width - 60)/2
        $0.itemSize = CGSize(width: width, height: width + 31)
        $0.minimumLineSpacing = 20
        $0.minimumInteritemSpacing = 20
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout) --> {
        $0.register(PortfolioCollectionViewCell.nib,
                    forCellWithReuseIdentifier: PortfolioCollectionViewCell.nameOfClass)

    }
    private let addDesignButton = UIButton()
    private let hintButton = UIButton() --> {
        $0.setTitle("TAP + \nTo CREATE YOUR FIRST DESIGN", for: .normal)
        $0.titleLabel?.font = UIFont.fontMedium(ofSize: 17)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.numberOfLines = 0
        $0.titleLabel?.textAlignment = .center
    }
    private let createDesignView = NewDeign()
    private var popBottomConstraints = [Constraint]()
    private let viewModel: HomePageViewModelPrototype
    private let disposeBag = DisposeBag()
}

// MARK: UI setup
private extension HomePageViewController {
    func setupNav() {
        let logoImage = UIImageView(image: #imageLiteral(resourceName: "Design"))
        logoImage.contentMode = .scaleAspectFit
        navigationItem.titleView = logoImage
    }
    
    func setupUI() {
        [collectionView, addDesignButton, hintButton].forEach { view.addSubview($0) }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(15)
            $0.left.right.equalToSuperview().inset(20)
        }
        addDesignButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(collectionView.snp.bottom).offset(10)
        }
        hintButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.greaterThanOrEqualToSuperview().inset(20)
        }
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        addDesignButton.setImage(#imageLiteral(resourceName: "Icon_add_button"), for: .normal)
        
        Observable.of(addDesignButton.rx.tap, hintButton.rx.tap)
            .merge()
            .bind { [weak self] _ in
                self?.popCreateNewDesign()
            }.disposed(by: disposeBag)
        
        setupPopup()
    }
        
    func setupPopup() {
        [createDesignView].forEach {
            view.addSubview($0)
            $0.alpha = 0
        }
        createDesignView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            popBottomConstraints.append(make.bottom.equalToSuperview().inset(0).constraint)
        }
        createDesignView.cancelButton.rx.tap
            .bind { [weak createDesignView] _ in
                createDesignView?.alpha = 0
                createDesignView?.endEditing(true)
            }.disposed(by: disposeBag)
        createDesignView.confirmButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.createDesignView.alpha = 0
                self.createDesignView.endEditing(true)
                self.viewModel.createNewDesign()
            }.disposed(by: disposeBag)

        createDesignView.textField.rx.text
            .bind(to: viewModel.newDesignName)
            .disposed(by: disposeBag)
    }

    func binding() {
        viewModel.designs
            .bind(to: collectionView.rx.items(cellIdentifier: PortfolioCollectionViewCell.nameOfClass,
                                              cellType: PortfolioCollectionViewCell.self)) { _, viewModel, cell in
                cell.config(viewModel: viewModel)
            }
            .disposed(by: disposeBag)

        viewModel.designs
            .map { $0.isEmpty }
            .subscribe(onNext: { [weak collectionView, weak hintButton] noDesign in
                collectionView?.isHidden = noDesign
                hintButton?.isHidden = !noDesign
            }).disposed(by: disposeBag)
    }
}

// MARK: UI Event
private extension HomePageViewController {
    func popCreateNewDesign() {
        createDesignView.reset()
        createDesignView.textField.becomeFirstResponder()
        createDesignView.alpha = 0
        UIView.animate(
            withDuration: 0.4,
            animations: { [weak createDesignView] in
                createDesignView?.alpha = 1
            })
    }
}

// MARK: Observe
private extension HomePageViewController {
    func keyboardObserve() {
        RxKeyboard.instance.visibleHeight.asObservable()
            .subscribe(onNext: { [weak self] height  in
                self?.popBottomConstraints.forEach { $0.update(inset: height + 5)}
            }).disposed(by: disposeBag)
    }
}
