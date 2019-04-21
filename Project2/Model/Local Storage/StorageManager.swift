//
//  StorageManager.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/19.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import CoreData
import UIKit

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
        newDesign: ALDesignView,
        createTime: Int64,
        designName: String,
        frame: CGRect,
        backgroundColor: UIColor?,
        backgroundImage: UIImage?,
        completion: (Result<Void>) -> Void) {
        
        let design = Design(context: viewContext)
        
        design.mapping(newDesign)
        
        design.frame = frame as NSObject
        
        design.createTime = createTime
        
        design.designName = designName
        
        if backgroundColor == nil {

            design.backgroundColor = nil
          
        } else {
            
            guard let color = backgroundColor else { return }
            
            design.backgroundColor = color as NSObject
        }
       
        if backgroundImage == nil {
            
            design.backgroundImage = nil
            
        } else {
            
            guard let image = backgroundImage else { return }
            
            design.backgroundImage = image as NSObject
            
        }
        
        do {
            
            try viewContext.save()
            
            completion(Result.success(()))
            
        } catch {
            
            completion(Result.failure(error))
        }
        
    }
}

private extension Design {
    
    func mapping(_ object: ALDesignView) {
        
        images = NSSet(array:
        
            object.subImages.map({ image in
                
                print(object.subImages)
                
                print(object.subImages[0].index)
                
                print(object.subImages[1].index)
                
                let alImage = Image(context: StorageManager.shared.viewContext
                )
                
                alImage.mapping(image)
                
                return alImage
                
            })
        
        )
    }
}

private extension Image {
    
    func mapping(_ object: ALImageView) {
        
        if object.image != nil {
            
            guard let imageToSave = object.image else { return }
            
            image = imageToSave as NSObject
        }
        
        frame = object.frame as NSObject
        
        print("------index-------")
        
        print(object.index)
        
        index = Int16(object.index)
    }
    
}
