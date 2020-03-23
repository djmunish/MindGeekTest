//
//  SecuredTests.swift
//  SecuredTests
//
//  Created by Ankur Sehdev on 22/03/20.
//  Copyright © 2020 Munish. All rights reserved.
//

import XCTest
@testable import secured

class securedTests: XCTestCase {

    var sut: SetupViewController!
    
    override func setUp(){
        sut = SetupViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
   
    //MARK: - Test Encryptor - Same Hash String produced for same inputs
    func testMD5Encryptor(){
        let passcode = EncryptorHelper.MD5(string: "Hello")
        let passcodeTest = EncryptorHelper.MD5(string: "Hello")
        XCTAssertEqual(passcode, passcodeTest)
    }
    
}
