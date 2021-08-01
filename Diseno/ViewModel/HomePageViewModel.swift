//
//  HomePageViewModel.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/7/27.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol HomePageViewModelInput: AnyObject {
    var newDesignName: BehaviorRelay<String?> { get }

    func createNewDesign()
    func showPortfoliAction(for design: Design)
}

protocol HomePageViewModelOutput: AnyObject {
    var designs: BehaviorRelay<[PortfolioCellViewModel]> { get }
    var showManageView: PublishRelay<ManagePortfolioViewModelPrototype> { get }
    var showNotification: PublishRelay<String> { get }
    var showError: PublishRelay<String> { get }
}

typealias HomePageViewModelPrototype =
    HomePageViewModelInput &
    HomePageViewModelOutput &
    ManagePortfolioViewModelPrototype

class HomePageViewModel: HomePageViewModelPrototype {
    // MARK: Output
    let designs = BehaviorRelay<[PortfolioCellViewModel]>(value: [])
    let showManageView = PublishRelay<ManagePortfolioViewModelPrototype>()
    let showNotification = PublishRelay<String>()
    let showError = PublishRelay<String>()

    // MARK: HomePageViewModelInput
    let newDesignName = BehaviorRelay<String?>(value: nil)

    func createNewDesign() {
        coordinator.goDesignPage()
    }

    func showPortfoliAction(for design: Design) {
        onFocueDesign = design
        showManageView.accept(self)
    }

    func receiveAction(_ actionType: PortfolioManageType) {
        guard let onFocueDesign = onFocueDesign else { return }
        switch actionType {
        case .open:
            break
        case .download:
            guard let screenshot = onFocueDesign.screenshot,
                    let image = DSFileManager.loadImageFromDiskWith(fileName: screenshot) else {
                return
            }
            DispatchQueue.main.async {
                self.imageSaver?.writeToPhotoAlbum(image: image)
            }
        default:
            break
        }
    }

    init(coordinator: AppCoordinatorPrototype) {
        self.coordinator = coordinator
        imageSaver = ImageSaver(
            successHandler: {
                self.showNotification.accept("Saved to camera roll")
            },
            failedHandler: {
                self.showError.accept(DSError.saveImageFail.title)
            })
        fetchDesign()
    }

    private var onFocueDesign: Design?
    private var imageSaver: ImageSaver?
    private let storageManager = StorageManager.shared
    private let coordinator: AppCoordinatorPrototype
}

private extension HomePageViewModel {
    func fetchDesign() {
        storageManager.fetchDesigns(completion: { result in
            guard case let .success(design) = result else {
                print("fetch design failed")
                return
            }
            self.designs.accept(design.map { PortfolioCellViewModel(design: $0, parent: self) })
        })
    }
}
