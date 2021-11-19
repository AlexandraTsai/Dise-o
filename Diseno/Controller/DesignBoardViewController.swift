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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Prepare the toolView
        initialToolView()
    }

    private let designBoard = UIImageView() --> {
        $0.backgroundColor = .white
    }
    private let plusButton = UIButton() --> {
        $0.backgroundColor = UIColor.Primary.background
        $0.clipsToBounds = true
        $0.setImage(#imageLiteral(resourceName: "Icon_add_button").tinted(color: UIColor.Primary.highLight), for: .normal)
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
    private let toolView = ToolView()
    private let imagePicker = UIImagePickerController()
    private weak var viewModel: DesignBoardViewModelProtocol?
    private let disposeBag = DisposeBag()
}

// MARK: - Setup UI
private extension DesignBoardViewController {
    func setupUI() {
        view.backgroundColor = UIColor.Primary.background
        view.addSubview(designBoard)
        designBoard.snp.makeConstraints {
            $0.height.equalTo(designBoard.snp.width)
            $0.width.equalTo(Constant.boardWidth)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
        }

        view.addSubview(plusButton)
        plusButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.right.equalToSuperview().inset(Constant.padding)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }

        view.addSubview(toolView)
        toolView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-70)
            $0.bottom.equalToSuperview()
        }
        toolView.isHidden = true
        toolView.delegate = self
    }

    func setupGesture() {
//        view.rx.tapGesture()
//            .when(.recognized)
//            .subscribe(onNext: { [weak self] _ in
//                self?.viewModel?.onFucus(.none)
//                self?.onFocusView = nil
//            }).disposed(by: disposeBag)

//        designContainerView.rx.tapGesture()
//            .when(.recognized)
//            .subscribe(onNext: { [weak self] _ in
//                self?.viewModel?.onFucus(.container)
//                self?.onFocusView = self?.designContainerView
//            }).disposed(by: disposeBag)

        plusButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.showToolView()
            }).disposed(by: disposeBag)
    }

    func binding() {
        viewModel?.elements
            .subscribe(onNext: { [weak self] elements in
                guard let self = self else { return }
                self.designBoard.subviews.forEach {
                    $0.removeFromSuperview()
                }
                elements.forEach {
                    let converted = ElementConvertor.convert(elements: $0)
                    self.designBoard.addSubview(converted)
                }
            }).disposed(by: disposeBag)
    }

    func prepareForOnFocusView() {
        guard let onFocusView = onFocusView else { return }
        onFocusView.layer.borderWidth = 1
        onFocusView.layer.borderColor = UIColor.Primary.highLight.cgColor
    }
}

// MARK: - Actions
private extension DesignBoardViewController {
    func initialToolView() {
        toolView.transform = .init(translationX: 0,
                                   y: toolView.frame.size.height)
        toolView.isHidden = false
    }

    func showToolView() {
        UIView.animate(withDuration: 0.5,
                       animations: {
            self.toolView.transform = .identity
            self.plusButton.transform = .init(rotationAngle: .pi / 4)
        }, completion: { _ in
            self.plusButton.isHidden = true
        })
    }

    func hideToolView() {
        UIView.animate(withDuration: 0.5,
                       animations: {
            self.toolView.transform = .init(translationX: 0,
                                            y: self.toolView.frame.size.height)
            self.plusButton.transform = .identity
        }, completion: { _ in
            self.plusButton.isHidden = false
        })
    }
}

// MARK: - Add components
private extension DesignBoardViewController {
    func displayCamera() {
        guard PhotoAuthManager.authedCamera else {
            present(AccessAlertHandler.alert(for: .camera), animated: true)
            return
        }
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }

    func displayPhotoLibrary() {
        guard PhotoAuthManager.authedPhotoLibrary,
            let vm = viewModel else {
            present(AccessAlertHandler.alert(for: .photo), animated: true)
            return
        }
        let vc = PhotoLibraryViewController(viewModel: PhotoLibraryViewModel(parent: vm))
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

// MARK: - ToolViewDelegate
extension DesignBoardViewController: ToolViewDelegate {
    func didSelect(tool: PlusMenuType) {
        switch tool {
        case .image:
            let sheet = UIAlertController(title: "Add Image", message: "", preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "Photo", style: .default) {_ in
                self.displayPhotoLibrary()
            })
            sheet.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
                self.displayCamera()
            })
            sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(sheet, animated: true)
        case .text:
            break
        case .shape:
            break
        }
    }

    func close(_ toolView: ToolView) {
        hideToolView()
    }
}

// MARK: - UIImagePickerControllerDelegate
extension DesignBoardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        // did take camera image
        viewModel?.didAddImage(image)
        picker.dismiss(animated: true)
    }
}
