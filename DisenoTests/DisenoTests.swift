//
//  Project2Tests.swift
//  Project2Tests
//
//  Created by 蔡佳宣 on 2019/5/10.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import XCTest
import CoreData
@testable import Diseno

class DisenoTests: XCTestCase {
    
//    var sut: StorageManager!

    override func setUp() {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
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
    
    func test_init_coreDataManager() {
        
        let instance = StorageManager.shared
        XCTAssertNotNil(instance)
        
    }
    
    func test_coreDataStackInitialization() {
        
        //Arrange
        let coreDataStack = StorageManager.shared.persistanceContainer
        
        //Assert
        XCTAssertNotNil(coreDataStack)
        
    }
    
    func test_create_person() {
        
        
        
        
        
    }
    
    func testAlexandra() {
        print("heeeeeeeeeee")
        
        //3A 原則 - Arrange, Action, Assert
        
        //        Arrange:
        let aaaa = 10
        let bbbb = 20
        let expectedResult = aaaa + bbbb
        
        //        Action:
        let actualResult = add(aaaa: aaaa, bbbb: bbbb)
        
        //        Assert:
        XCTAssertEqual(expectedResult, actualResult)
        
    }
    
    func add(aaaa: Int, bbbb: Int) -> Int {
        
        return 30
    }
    
}



