//
//  PlusMenuViewController.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/8/29.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit

enum PlusMenuType: CaseIterable {
    case image
    case text
    case shape

    var image: UIImage {
        switch self {
        case .image: return #imageLiteral(resourceName: "noun_photos_1739914")
        case .text: return #imageLiteral(resourceName: "Icon_text")
        case .shape: return #imageLiteral(resourceName: "Icon_shape")
        }
    }
}

class PlusMenuViewController: UIViewController {
    init() {
//        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createBlackBackground()
        createMenu()
        setupGesture()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showMenuAnimation()
    }

    private let bgView = UIView()
    private var menuContainer = UIView() --> {
        $0.backgroundColor = UIColor.Primary.background
    }
    private let flowLayout = UICollectionViewFlowLayout() --> {
        let count = CGFloat(PlusMenuType.allCases.count)
        let width: CGFloat = 80
        $0.itemSize = .init(width: width, height: width)
        $0.minimumInteritemSpacing = (UIScreen.width - LC.collectionViewLRInset * 2 - width * count) / (count - 1)
    }
    private lazy var menuCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout) --> {
        $0.contentInset = .init(top: 0, left: LC.collectionViewLRInset, bottom: 0, right: LC.collectionViewLRInset)
        $0.register(ToolCollectionViewCell.self, forCellWithReuseIdentifier: ToolCollectionViewCell.nameOfClass)
    }
}

// MARK: - Setup UI
private extension PlusMenuViewController {
    func createBlackBackground() {
        bgView.backgroundColor = .black.withAlphaComponent(0.64)
        view.addSubview(bgView)
        bgView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        bgView.addGestureRecognizer(tap)
    }

    func createMenu() {
        view.addSubview(menuContainer)
        menuContainer.snp.remakeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(0)
            $0.top.equalTo(view.snp.bottom)
        }
        menuContainer.layer.cornerRadius = 12
        menuContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        menuContainer.clipsToBounds = true

        setupCollectionView()
        setupHeader()
    }

    func setupCollectionView() {
        menuCollectionView.backgroundColor = .clear
        menuContainer.addSubview(menuCollectionView)
        menuCollectionView.snp.remakeConstraints {
            $0.left.right.bottom.equalToSuperview()
        }
        menuCollectionView.isScrollEnabled = false
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
    }

    func setupHeader() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 56))
        view.backgroundColor = .clear
        let miniBar = UIView()
        miniBar.layer.cornerRadius = 2
        miniBar.backgroundColor = .gray
        view.addSubview(miniBar)
        miniBar.snp.makeConstraints {
            $0.height.equalTo(4)
            $0.width.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(12)
        }
        menuContainer.addSubview(view)
        view.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(60)
            $0.bottom.equalTo(menuCollectionView.snp.top)
        }
    }
}

// MARK: UI Events
private extension PlusMenuViewController {
    func showMenuAnimation() {
        print(view.safeAreaInsets.bottom)
        // Header + collectionView + safeArea.bottom
        let height = 60 + flowLayout.itemSize.height + view.safeAreaInsets.bottom
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.9,
            options: .curveEaseInOut,
            animations: {
                self.menuContainer.snp.updateConstraints {
                    $0.height.equalTo(height)
                    $0.top.equalTo(self.view.snp.bottom).offset(-height)
                }
                self.menuContainer.superview?.layoutIfNeeded()
        })
    }

    func setupGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        pan.delegate = self
        menuCollectionView.addGestureRecognizer(pan)
    }

    @objc
    func didPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            break
        case .changed:
            let trans = sender.translation(in: bgView)
            if trans.y < 0 { return }
            menuContainer.transform = CGAffineTransform(translationX: 0, y: trans.y)
        case .ended:
            let velocity = sender.velocity(in: bgView)
            let trans = sender.translation(in: bgView)
            let height = menuContainer.frame.size.height
            if velocity.y > 500 || trans.y > height * 0.3 {
                dismissMenu()
            } else {
                menuContainer.transform = .identity
            }
        default:
            // cancel here
            menuContainer.transform = .identity
        }
    }

    @objc
    func dismissMenu() {
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {
                        self.bgView.alpha = 0
                        self.menuContainer.snp.updateConstraints {
                            $0.width.equalToSuperview()
                            $0.top.equalTo(self.view.snp.bottom)
                        }
                        self.menuContainer.superview?.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false)
        })
    }
}

// MARK: - UIGestureRecognizerDelegate
extension PlusMenuViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        guard menuCollectionView.contentOffset.y <= 0 else { return false }
        let trans = pan.translation(in: bgView)
        return trans.y > 0
    }
}

extension PlusMenuViewController: UICollectionViewDelegate {}

extension PlusMenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        PlusMenuType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToolCollectionViewCell.nameOfClass,
                                                            for: indexPath) as? ToolCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.config(image: PlusMenuType.allCases[indexPath.row].image, imageInset: 20)
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 20
        return cell
    }
}

private typealias LC = LocalConstant

private enum LocalConstant {
    static let collectionViewLRInset: CGFloat = 20
    static let collectionViewItemSpace: CGFloat = 20
}
