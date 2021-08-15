//
//  AppCoordinator.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/7/18.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var rootViewController: UIViewController? { get }
    
    func start()
}

protocol AppCoordinatorProtocol {
    func goToHomePage()
    func goDesignPage(with design: Design?)
}

typealias AppCoordinatorPrototype = Coordinator & AppCoordinatorProtocol

class AppCoordinator: AppCoordinatorPrototype {
    // MARK: Coordinator
    var rootViewController: UIViewController? {
        window.rootViewController
    }
    
    func start() {
        window.rootViewController = LaunchScreenViewController(coordinator: self)
    }

    // MARK: AppCoordinatorProtocol
    func goToHomePage() {
        homeViewModel = HomePageViewModel(coordinator: self,
                                          storageManager: storageManager,
                                          fileManager: fileManager)
        homePageViewController = HomePageViewController(viewModel: homeViewModel!)
        let nav = UINavigationController(rootViewController: homePageViewController!)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.tintColor = UIColor.black
        nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        nav.navigationBar.shadowImage = UIImage()
        rootViewController?.present(nav, animated: true)
        navigation = nav
    }

    func goDesignPage(with design: Design?) {
        guard let designVC = UIStoryboard(
            name: "Main",
            bundle: nil).instantiateViewController(
                withIdentifier: String(describing: DesignViewController.self)) as? DesignViewController
            else { return }
        designVC.viewModel = DesignViewModel(entry: design != nil ?
                                                .editing(design!) :
                                                .new,
                                             fileManager: fileManager,
                                             storageManager: storageManager,
                                             coordinator: self)
        homePageViewController?.show(designVC, sender: nil)
    }

    init(window: UIWindow,
         storageManager: StorageManager,
         fileManager: DSFileManager) {
        self.window = window
        self.storageManager = storageManager
        self.fileManager = fileManager
    }

    private var homePageViewController: HomePageViewController?
    private var homeViewModel: HomePageViewModelPrototype?
    private var navigation: UINavigationController?
    private let storageManager: StorageManager
    private let fileManager: DSFileManager
    private let window: UIWindow
}

extension AppCoordinator: DesignCoordinator {
    func designDone() {
        homeViewModel?.updateDesign()
        navigation?.popViewController(animated: true)
    }
}
