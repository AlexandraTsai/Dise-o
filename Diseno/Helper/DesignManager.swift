//
//  DesignManager.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/7/17.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import Foundation
import CoreData

class DesignManager {
    static let shared = DesignManager()
    
    // MARK: Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data stack
    /*
    The persistent container for the application. This implementation
    creates and returns a container, having loaded the store for the
    application to it. This property is optional since there are legitimate
    error conditions that could cause the creation of the store to fail.
   */
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Project2")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
      
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
