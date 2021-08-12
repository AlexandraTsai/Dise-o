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
import RxGesture
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
        bindCollectionView()
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
        $0.contentInset = .init(top: 20, left: 20, bottom: 0, right: 20)

    }
    private let addDesignButton = UIButton()
    private let hintButton = UIButton() --> {
        $0.setTitle("TAP + \nTo CREATE YOUR FIRST DESIGN", for: .normal)
        $0.titleLabel?.font = UIFont.fontMedium(ofSize: 17)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.numberOfLines = 0
        $0.titleLabel?.textAlignment = .center
    }
    /// Handle dismissing the popup view when tapping on this view.
    private let touchToDismissView = UIView()
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
            $0.left.right.equalToSuperview()
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

        setupTouchToDismissView()
        setupPopup()
    }

    func setupTouchToDismissView() {
        view.addSubview(touchToDismissView)
        touchToDismissView.snp.makeConstraints { $0.edges.equalToSuperview() }
        touchToDismissView.backgroundColor = .clear
        touchToDismissView.isHidden = true
        touchToDismissView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak view, weak touchToDismissView] _ in
                guard let popup = view?.subviews.last as? PopupView else {
                    return
                }
                popup.removeFromSuperview()
                touchToDismissView?.isHidden = true
            }).disposed(by: disposeBag)
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
            .map { $0.isEmpty }
            .subscribe(onNext: { [weak collectionView, weak hintButton] noDesign in
                collectionView?.isHidden = noDesign
                hintButton?.isHidden = !noDesign
            }).disposed(by: disposeBag)

        viewModel.showManageView
            .subscribe(onNext: { [weak self] manageVM in
                let selectionView = ManagePortfolioView(viewModel: manageVM)
                self?.showPopupView(selectionView)
            }).disposed(by: disposeBag)

        viewModel.showRenameInput
            .subscribe(onNext: { [weak self] viewModel in
                let renameView = RenameView(viewModel: viewModel)
                self?.showPopupView(renameView)
            }).disposed(by: disposeBag)

        viewModel.showNotification
            .subscribe(onNext: { text in
                let banner = NotificationBanner(title: text, style: .success)
                banner.applyStyling(alignment: .center)
                banner.show()
            }).disposed(by: disposeBag)

        viewModel.showError
            .subscribe(onNext: { text in
                let banner = NotificationBanner(title: text, style: .fail)
                banner.applyStyling(alignment: .center)
                banner.show()
            }).disposed(by: disposeBag)
    }

    func bindCollectionView() {
        viewModel.designs
            .bind(to: collectionView.rx.items(cellIdentifier: PortfolioCollectionViewCell.nameOfClass,
                                              cellType: PortfolioCollectionViewCell.self)) { _, viewModel, cell in
                cell.config(viewModel: viewModel)
            }
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .bind { [weak viewModel] indexPath in
                viewModel?.didSelect(at: indexPath)
            }.disposed(by: disposeBag)
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

    func showPopupView(_ popup: PopupView) {
        view.addSubview(popup)
        popup.snp.makeConstraints {
            popBottomConstraints.append($0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30).constraint)
            $0.left.right.equalToSuperview().inset(20)
        }
        popup.doneHandler = { [weak self] in
            popup.removeFromSuperview()
            self?.touchToDismissView.isHidden = true
        }
        touchToDismissView.isHidden = false
    }
}

// MARK: Observe
private extension HomePageViewController {
    func keyboardObserve() {
        RxKeyboard.instance.visibleHeight.asObservable()
            .subscribe(onNext: { [weak self] height  in
                guard let self = self else { return }
                guard height != 0 else {
                    self.popBottomConstraints.forEach { $0.update(inset: self.view.frame.height / 3) }
                    return
                }
                self.popBottomConstraints.forEach { $0.update(inset: height + 5)}
            }).disposed(by: disposeBag)
    }
}
