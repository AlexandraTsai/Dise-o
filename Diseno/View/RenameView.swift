//
//  RenameView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/24.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RenameView: PopupView {
    var doneHandler: (() -> Void)?

    init(frame: CGRect = .zero, viewModel: RenameDesignViewModelPrototype) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setup()
        setupLayout()
        setupTitle()
        settingForTextField()
        binding()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupLayout()
        setupTitle()
        settingForTextField()
    }

    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let cancelButton = UIButton()
    private let saveButton = UIButton()

    private var viewModel: RenameDesignViewModelPrototype?
    private let disposeBag = DisposeBag()
}

private extension RenameView {
    func setup() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 20

        //Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 12
        layer.shadowOpacity = 1
    }

    func setupLayout() {
        //Add sub views
        addSubview(textField)
        textField.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.equalToSuperview().inset(30)
            $0.height.equalTo(30)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(20)
        }
        addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.left.equalTo(cancelButton.snp.right).offset(20)
            $0.centerY.height.width.equalTo(cancelButton)
            $0.right.equalToSuperview().inset(20)
        }

        saveButton.layer.cornerRadius = 13
        cancelButton.layer.cornerRadius = 13

        saveButton.backgroundColor = UIColor.black
        cancelButton.backgroundColor = UIColor.gray

    }

    func setupTitle() {
        //Title
        titleLabel.text = "Rename Design"
        titleLabel.font = UIFont(name: FontName.futura.rawValue, size: 20)

        saveButton.setTitle("SAVE", for: .normal)
        cancelButton.setTitle("CANCEL", for: .normal)

        saveButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 13)
        cancelButton.titleLabel?.font = UIFont(name: FontName.futura.rawValue, size: 13)
    }

    func settingForTextField() {
        textField.font = UIFont(name: FontName.futura.rawValue, size: 13)
        textField.backgroundColor = .white
        textField.layer.shadowColor = UIColor.gray.cgColor
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        textField.layer.shadowRadius = 0.0
        textField.layer.shadowOpacity = 1.0

    }
}

private extension RenameView {
    func binding() {
        guard let viewModel = viewModel else {
            return
        }
        // Two-way binding
        viewModel.designName
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)

        textField.rx.text
            .bind(to: viewModel.designName)
            .disposed(by: disposeBag)

        saveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                viewModel.rename()
                self?.doneHandler?()
            }).disposed(by: disposeBag)

        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.doneHandler?()
            }).disposed(by: disposeBag)
    }
}
