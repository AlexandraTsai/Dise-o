//
//  TextTableViewTest.swift
//  DisenoTests
//
//  Created by 蔡佳宣 on 2019/5/15.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import XCTest
import UIKit
@testable import Diseno

class TextTableViewTest: XCTestCase {
    
    var tableView: UITableView!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        tableView = UITableView()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        tableView = nil
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
    
    func test_setup_fontSizeCell_success() {
        
        //Arrange
        let text = FontName.alNile.rawValue
        let textColor = UIColor.red

        tableView.al_registerCellWithNib(identifier: String(describing: FontTableViewCell.self), bundle: nil)
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: FontTableViewCell.self)) as? FontTableViewCell else { return }
        
        //Action
        cell.setupCell(with: text, color: textColor)
        
        //Assert
        XCTAssertEqual(text, cell.fontLabel?.text)
        XCTAssertEqual(textColor, cell.fontLabel?.textColor)

    }

}
