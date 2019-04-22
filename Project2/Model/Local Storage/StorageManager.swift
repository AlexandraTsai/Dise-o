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
            
            {(_, error) in
            
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
        
        request.sortDescriptors = [NSSortDescriptor(key: ALDesign.createTime, ascending: false)]
        
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
    
    func updateDesign(
        design: ALDesignView,
        createTime: Int64,
        completion: (Result<Void>) -> Void) {
        
        let request = NSFetchRequest<Design>(entityName: Entity.design.rawValue)
        
        request.predicate = NSPredicate(format: "createTime == %lld", createTime)
 
        do {
            
            let designs = try viewContext.fetch(request)
            
            for object in designs {
                
                let updateTime = Int64(Date().timeIntervalSince1970)
              
                object.setValue(design.backgroundColor, forKey: "backgroundColor")
                object.setValue(updateTime, forKey: "createTime")
                object.setValue(design.image, forKey: "backgroundImage")
                
                try viewContext.save()
                
                completion(Result.success(()))
                
            }
            
        } catch {
            
            completion(Result.failure(error))
            
        }
        
    }
}

private extension Design {
    
    func mapping(_ object: ALDesignView) {
        
        images = NSSet(array:
        
            object.subImages.map({ imageView in
                
                let alImageView = Image(context: StorageManager.shared.viewContext
                )
                
                alImageView.mapping(imageView)
                
                return alImageView
                
            })
        
        )
        
        texts = NSSet(array:
        
            object.subTexts.map({ textView in
                
                let alTextView = Text(context: StorageManager.shared.viewContext)
                
                alTextView.mapping(textView)
                
                return alTextView
                
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
        
        guard let objectIndex = object.index else { return }
        
        index = Int16(objectIndex)
    }
    
}

private extension Text {
    
    func mapping(_ object: ALTextView) {
        
        if object.text != nil {
            
            guard let textToSave = object.text else { return }
            
            attributedText = textToSave as NSObject
        }
    }
}
