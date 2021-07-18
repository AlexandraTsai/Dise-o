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
    func goDesignPage()
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
        homeViewModel = HomePageViewModel(coordinator: self)
        homePageViewController = HomePageViewController(viewModel: homeViewModel!)
        let nav = UINavigationController(rootViewController: homePageViewController!)
        nav.modalPresentationStyle = .fullScreen
        rootViewController?.present(nav, animated: true)
    }

    func goDesignPage() {
        guard let designVC = UIStoryboard(
            name: "Main",
            bundle: nil).instantiateViewController(
                withIdentifier: String(describing: DesignViewController.self)) as? DesignViewController
            else { return }

        designVC.loadViewIfNeeded()

        designVC.designView.designName = homeViewModel?.newDesignName.value ?? ""
        homePageViewController?.show(designVC, sender: nil)
    }

    init(window: UIWindow) {
        self.window = window
    }

    private var homePageViewController: HomePageViewController?
    private var homeViewModel: HomePageViewModelPrototype?
    private let window: UIWindow
}
