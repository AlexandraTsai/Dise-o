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

class HomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupUI()
    }

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let addDesignButton = UIButton()
    private let hintButton = UIButton() --> {
        $0.setTitle("TAP + \nTo CREATE YOUR FIRST DESIGN", for: .normal)
        $0.titleLabel?.font = UIFont.fontMedium(ofSize: 17)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.numberOfLines = 0
        $0.titleLabel?.textAlignment = .center
    }
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
        
        Observable.combineLatest(addDesignButton.rx.tap, hintButton.rx.tap)
            .subscribe(onNext: { [weak self] _ in
                self?.createNewDesign()
            }).disposed(by: disposeBag)
    }
}

// MARK: UI Event
private extension HomePageViewController {
    func createNewDesign() {
        
    }
}
