//
//  ScreenTests.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 08.01.2017.
//  Copyright © 2017 Marcin Maciaszczyk. All rights reserved.
//

import XCTest

@testable import Lightning

class ScreenTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitPerformance() {
        self.measure {
            _ = Screen(id: 0, resolution: CGSize(width: 1280, height: 1024))
        }
    }
    
}
