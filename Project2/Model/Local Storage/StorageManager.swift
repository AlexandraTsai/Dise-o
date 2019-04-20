//
//  StorageManager.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/19.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import CoreData

typealias ALDesignResults = (Result<[Design]>) -> Void

typealias ALDesignResult = (Result<Design>) -> Void

class StorageManager {
    
    private enum Entity: String, CaseIterable {
        
        case design = "Design"
        
        case image = "Image"
        
        case text = "Text"
        
        case shape = "Shape"
        
    }
    
    private struct ALDesign {
        
        static let createTime = "createTime"
        
    }
    
    static let shared = StorageManager()
    
    private init() {
        print("Core data file path: \(NSPersistentContainer.defaultDirectoryURL())")
    }
    
    lazy var persistanceContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Desiging")
        
        container.loadPersistentStores(completionHandler:
            
            { (description, error) in
            
                if let error = error {
                    fatalError("Unresolved error \(error)")
                }
            })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        
        return persistanceContainer.viewContext
    }
    
    func fetchDesigns(completion: ALDesignResults) {
        
        let request = NSFetchRequest<Design>(entityName: Entity.design.rawValue)
        
        request.sortDescriptors = [NSSortDescriptor(key: ALDesign.createTime, ascending: true)]
        
        do {
            
            let orders = try viewContext.fetch(request)
            
            completion(Result.success(orders))
            
        } catch {
            
            completion(Result.failure(error))
        }
    }
    
    func saveAll(completion: (Result<Void>) -> Void) {
        
        do {
            try viewContext.save()
            completion(Result.success(()))
            
        } catch {
            
            completion(Result.failure(error))
        }
    }
    
    func saveDesign (
        createTime: Int64, designName: String, completion: (Result<Void>) -> Void) {
        
        let design = Design(context: viewContext)
        
        let image = Image(context: viewContext)
        
    
        
    }
}

private extension Design {
    
    func mapping(_ object: Design) {
        
        
    }
    
}
