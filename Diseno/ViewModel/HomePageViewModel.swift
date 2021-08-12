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
    func didSelect(at indexPath: IndexPath)
    func updateDesign()
}

protocol HomePageViewModelOutput: AnyObject {
    var designs: BehaviorRelay<[PortfolioCellViewModel]> { get }
    var showManageView: PublishRelay<ManagePortfolioViewModelPrototype> { get }
    var showNotification: PublishRelay<String> { get }
    var showRenameInput: PublishRelay<RenameDesignViewModelPrototype> { get }
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
    let showRenameInput = PublishRelay<RenameDesignViewModelPrototype>()
    let showError = PublishRelay<String>()

    // MARK: HomePageViewModelInput
    let newDesignName = BehaviorRelay<String?>(value: nil)

    func createNewDesign() {
        coordinator.goDesignPage(with: nil)
    }

    func showPortfoliAction(for design: Design) {
        onFocueDesign = design
        showManageView.accept(self)
    }

    func didSelect(at indexPath: IndexPath) {
        coordinator.goDesignPage(with: designs.value[indexPath.row].design)
    }

    func receiveAction(_ actionType: PortfolioManageType) {
        guard let onFocueDesign = onFocueDesign else { return }
        switch actionType {
        case .open:
            coordinator.goDesignPage(with: onFocueDesign)
        case .rename:
            showRenameInput.accept(RenameDesignViewModel(design: onFocueDesign, storeManager: storageManager, parent: self))
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

    func updateDesign() {
        fetchDesign()
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
