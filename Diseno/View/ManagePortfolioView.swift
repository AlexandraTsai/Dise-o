//
//  SelectionView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/23.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit
import RxSwift

protocol Popup: AnyObject {
    var doneHandler: (() -> Void)? { get set }
}

typealias PopupView = Popup & UIView

class ManagePortfolioView: PopupView {
    var doneHandler: (() -> Void)?

    init(viewModel: ManagePortfolioViewModelPrototype,
         frame: CGRect = .zero) {
        super.init(frame: frame)
        self.viewModel = viewModel
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    deinit {
        print(#function)
    }

    private let cancelButton = UIButton() --> {
        $0.backgroundColor = UIColor.DSColor.lightGray
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = UIFont.fontMedium(ofSize: 16)
        $0.alpha = 0.6
        $0.layer.cornerRadius = 15
        $0.setTitle("CANCEL", for: .normal)
    }
    private let closeButton = UIButton()
    private weak var viewModel: ManagePortfolioViewModelPrototype?
    private let disposeBag = DisposeBag()
}

private extension ManagePortfolioView {
    func setup() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 20

        //Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 12
        layer.shadowOpacity = 1

        //Add sub views
        setupLayout()
    }

    func setupLayout() {
        let actionContainer = UIStackView()
        actionContainer.axis = .vertical
        actionContainer.spacing = 15
        actionContainer.alignment = .center
        actionContainer.distribution = .fillEqually
        addSubview(actionContainer)
        actionContainer.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.left.right.equalToSuperview().inset(15)
        }

        PortfolioManageType.allCases.forEach { type in
            let button = UIButton()
            button.setTitle(type.title, for: .normal)
            button.titleLabel?.font = UIFont.fontMedium(ofSize: 16)
            button.setTitleColor(type.titleColor, for: .normal)
            button.backgroundColor = type.backgroundColor
            button.layer.cornerRadius = 17
            button.layer.borderWidth = type.borderWidth
            button.layer.borderColor = type.borderColor?.cgColor
            actionContainer.addArrangedSubview(button)
            button.snp.makeConstraints {
                $0.left.right.equalToSuperview()
            }
            button.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.viewModel?.receiveAction(type)
                    self.doneHandler?()
                }).disposed(by: disposeBag)
        }

        //Cancel Button
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(actionContainer.snp.bottom).offset(15)
            $0.left.right.equalToSuperview().inset(50)
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().inset(20)
        }

        //Close Button
        addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(10)
            $0.height.width.equalTo(20)
        }
        closeButton.setImage(#imageLiteral(resourceName: "noun_Cancel"), for: .normal)

        [cancelButton, closeButton].forEach {
            $0.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    self?.doneHandler?()
                }).disposed(by: disposeBag)
        }
    }
}

extension PortfolioManageType {
    var title: String {
        switch self {
        case .open: return "Open"
        case .download: return "Download"
        case .share: return "Share"
        case .rename: return "Rename"
        case .delete: return "Delete"
        }
    }

    var titleColor: UIColor {
        switch self {
        case .open, .delete:
            return .white
        default:
            return .black
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .open:
            return UIColor.DSColor.heavyGreen
        case .delete:
            return UIColor.DSColor.red
        default:
            return .white
        }
    }

    var borderColor: UIColor? {
        switch self {
        case .open, .delete:
            return nil
        default:
            return UIColor.DSColor.heavyGreen
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .open, .delete:
            return 0
        default:
            return 1
        }
    }
}
