//
//  Project2Tests.swift
//  Project2Tests
//
//  Created by 蔡佳宣 on 2019/5/10.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import XCTest

class Project2Tests: XCTestCase {
    
    var array = [Int]()

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
    
    func feb(number: Int) -> Int {
        
        array = []
        
//        if number < 0 {
//
//            return nil
//        }
        
        for num in 0...number {
            
            if num == 0 || num == 1 {
                
                array.append(1)
                
            } else {
                
                let first = array[num-2]
                let second = array[num-1]
                
                array.append(first+second)
            }

        }
        
        return array[number]
    }

    func testFeb() {
        
        let actualResult = 8
        
        let expectedResult = feb(number: 5)
        
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testFebCorrect() {
        
        let feb10 = feb(number: 10)
        let feb11 = feb(number: 11)
        let feb12 = feb10 + feb11
        
        XCTAssertEqual(feb12, feb(number: 12))
        
    }
    
    func testNegative() {
        
    }
    
    func testEmpty() {
        
    }
    
}
