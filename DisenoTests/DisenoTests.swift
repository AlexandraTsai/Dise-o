//
//  Project2Tests.swift
//  Project2Tests
//
//  Created by 蔡佳宣 on 2019/5/10.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import XCTest
import UIKit
import CoreData

@testable import Diseno

class DisenoTests: XCTestCase {
    
    var sut: StorageManager!
    
    lazy var manageObjectModel: NSManagedObjectModel = {
        
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        return managedObjectModel
    }()
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "Desiging", managedObjectModel: self.manageObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition(description.type == NSInMemoryStoreType)
            
            //Check if creating container wrong
            if let error = error {
                
                fatalError("Create an in-mem coordinator failed \(error)")
                
            }
        }
        
        return container
        
    }()
    
    override func setUp() {
        
        super.setUp()
        sut = StorageManager(container: mockPersistantContainer)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        
        flushData()
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
        }
    }
    
    func test_save_design_success() {
        
        //Arrange:
        let newDesign = ALDesignView()
        let createTime = Int64(9223372036854775000)

        //Action:
        let expectation = self.expectation(description: "Saving")
        var countAfterSave = 0
        
        sut.saveDesign(newDesign: newDesign, createTime: createTime, completion: { result in
            
            switch result {
            
            case .success:
                
                sut.fetchDesigns(completion: { (result) in
                
                switch result {
                    
                case .success(let design):
                    
                    countAfterSave = design.count
                    
                    expectation.fulfill()
                   
                case .failure: print("Fail to fetch")
                }
            })
                
            case .failure: print("Fail to save design")

            }
            
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    
        //Assert:
        XCTAssertEqual(countAfterSave, 1)
        
    }
    
    func test_fetch_all_design_success() {
        
        //Arrange: Given a storage with two designs
        initStubs()
        let expectation = self.expectation(description: "Fetch")
        
        //Action: fetch
        var count = 0
        
        sut.fetchDesigns( completion: { result in
            
            switch result {
                
            case .success(let designs):
                
               count = designs.count
               
               expectation.fulfill()
               
            case .failure:
                
                print("讀取資料發生錯誤")
            }
        })
        
        waitForExpectations(timeout: 5)
        
        //Assert:
        XCTAssertEqual(count, 2)
        
    }
    
    func test_update_design_success() {
    
        //Arrange
        let createTime = Int64(9223372036854775001)
        insertDesigns(designName: "Test1", screenshot: "screenshot1", createTime: createTime)
        let alDesign = ALDesignView()
        
        sut.fetchDesigns { (result) in
            
            switch result {
            case .success(let design):
                
                let designs = design as [Design]
                let originDesign = designs[0]
                
                originDesign.transformDesign(for: alDesign)
                alDesign.designName = "ChangeName"
                alDesign.createTime = originDesign.createTime
                
            case .failure: print("Fail to fetch design")
            }
            
            //Action
            let expectation = self.expectation(description: "Updating")
            var updatedDesign = Design()
            
            sut.updateDesign(design: alDesign,
                             createTime: alDesign.createTime!, completion: { (result) in
                                
                                switch result {
                                case .success:
                                    
                                    sut.fetchDesigns(completion: { (result) in
                                        
                                        switch result {
                                        case .success(let design):
                                            
                                            let designs = design as [Design]
                                            updatedDesign = designs[0]
                                            expectation.fulfill()
                                            
                                        case .failure: print("Fail to fetch design")
                                        }
                                        
                                    })
                                    
                                case .failure: print("Fail to update design")
                                    
                                }
                                
            })
            
            waitForExpectations(timeout: 5)
            
            //Assert:
            XCTAssertEqual(updatedDesign.designName, "ChangeName")
        }
        
    }
    
    func test_remove_design_success() {
        
        //Arrange
        insertDesigns(designName: "Test1", screenshot: "screenshot1", createTime: Int64(9223372036854775000))
        insertDesigns(designName: "Test2", screenshot: "screenshot2", createTime: Int64(9223372036854775001))
        
        sut.fetchDesigns { (result) in
            
            switch result {
            case .success(let designs):
                
                let numberOfCount = designs.count
                
                //Action
                let expectation = self.expectation(description: "Delete")
                
                sut.deleteDesign(designs[0], completion: { (result) in
                    
                    switch result {
                    case .success:
                        
                        expectation.fulfill()
                        
                    case .failure: print("Failure to delete")
                    }
                    
                })
                
                waitForExpectations(timeout: 5)
                
                XCTAssertEqual(numberOfItemsInPersistentStore(), numberOfCount-1)
                
            case .failure: print("Failure to fetch")
            }
        }
        
    }
    
}

extension DisenoTests {
    
    func initStubs() {
        
        insertDesigns(designName: "Test1", screenshot: "screenShot1", createTime: Int64(9223372036854775001))
        
        insertDesigns(designName: "Test2", screenshot: "screenShot2", createTime: Int64(9223372036854775002))
        
        do {
            try mockPersistantContainer.viewContext.save()
        } catch {
            print("create fakes error \(error)")
        
        }
        
    }
    
    func insertDesigns(designName: String, screenshot: String, createTime: Int64) {
        
        let obj = NSEntityDescription.insertNewObject(forEntityName: String(describing: Design.self),
                                                      into: mockPersistantContainer.viewContext)
        
        obj.setValue(designName, forKey: "designName")
        obj.setValue(screenshot, forKey: "screenshot")
        obj.setValue(createTime, forKey: "createTime")
        
    }
    
    // swiftlint:disable force_try
    func flushData() {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Design.self))
        
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        
        do {
            try mockPersistantContainer.viewContext.save()
            
        } catch {
            
        }
        
    }
    
    func numberOfItemsInPersistentStore() -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Design")
        let results = try! mockPersistantContainer.viewContext.fetch(request)
        return results.count
    }
    
    // swiftlint:enable force_try
    
}
