//
//  CalculateMethodTest.swift
//  DisenoTests
//
//  Created by 蔡佳宣 on 2019/5/15.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import XCTest
@testable import Diseno

class CalculateMethodTest: XCTestCase {

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
            // Put the code you want to measure the time of here.
        }
    }

    func test_angleBetweenTwoPoint_success() {
        
        //Arrange
        let pointA = CGPoint(x: 0, y: -20)
        let pointB = CGPoint(x: -30, y: 0)
        let origin = CGPoint(x: 0, y: 0)
        let expectedAngle = CGFloat.pi/2
        
        let testVC = UIViewController()
        
        //Action
        let actualAngle = testVC.angleBetween(pointA: pointA, pointB: pointB, origin: origin)
        
        //Assert
        XCTAssertEqual(expectedAngle, actualAngle)
        
    }
    
    func test_angleBetweenTwoPoint_fail() {
        
        //Arrange
        let pointA = CGPoint(x: 0, y: 20)
        let pointB = CGPoint(x: 30, y: 10)
        let origin = CGPoint(x: 0, y: 0)
        let expectedAngle = CGFloat.pi/2
        
        let testVC = UIViewController()
        
        //Action
        let actualAngle = testVC.angleBetween(pointA: pointA, pointB: pointB, origin: origin)
        
        //Assert
        XCTAssertNotEqual(expectedAngle, actualAngle)
        
    }
    
    func test_isClockWise_true() {
        
        //Arrange
        let pointA = CGPoint(x: 10, y: 20)
        let pointB = CGPoint(x: 0, y: 20)
        let origin = CGPoint(x: 0, y: 0)
        
        let testVC = UIViewController()
        
        //Action
        let actualResult = testVC.isClockwise(from: pointA, to: pointB, center: origin)
        
        //Assert
        XCTAssertEqual(actualResult, true)
    }
    
    func test_isClockWise_false() {
        
        //Arrange
        let pointA = CGPoint(x: 3, y: -3)
        let pointB = CGPoint(x: 4, y: -5)
        let origin = CGPoint(x: 0, y: 0)
        
        let testVC = UIViewController()
        
        //Action
        let actualResult = testVC.isClockwise(from: pointA, to: pointB, center: origin)
        
        //Assert
        XCTAssertEqual(actualResult, false)
    }

}
