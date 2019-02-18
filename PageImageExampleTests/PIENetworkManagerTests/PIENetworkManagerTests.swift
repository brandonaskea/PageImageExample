//
//  PIENetworkManagerTests.swift
//  PageImageExampleTests
//
//  Created by Brandon Askea on 2/17/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import XCTest

class PIENetworkManagerTests: XCTestCase {
    
    var networkManager: PIENetworkManager!

    override func setUp() {
        networkManager = PIENetworkManager()
    }

    override func tearDown() {
        networkManager = nil
    }

    func testDownloadImageContent() {
        networkManager.downloadImageContent { (errorMessage, content) in
            XCTAssert(errorMessage == nil)
        }
    }

}
