//
//  securedUITests.swift
//  securedUITests
//
//  Created by Ankur Sehdev on 22/03/20.
//  Copyright © 2020 Munish. All rights reserved.
//

import XCTest
@testable import secured

class securedUITests: XCTestCase {
    var sut: SetupViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        sut = SetupViewController()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        
        let app = XCUIApplication()
                
                
    }


}
