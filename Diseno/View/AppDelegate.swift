//
//  AppDelegate.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/1.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setWindow()
        appCoordinator = AppCoordinator(window: window!, storageManager: StorageManager.shared)
        appCoordinator?.start()
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        
        FirebaseApp.configure()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        DesignManager.shared.saveContext()
    }
    
    private var appCoordinator: AppCoordinator?
}

private extension AppDelegate {
    func setWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    }
}
