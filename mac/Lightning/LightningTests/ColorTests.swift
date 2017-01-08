//
//  ColorTests.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 08.01.2017.
//  Copyright © 2017 Marcin Maciaszczyk. All rights reserved.
//

import XCTest

@testable import Lightning

class ColorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testColorInitialization () {
        let color = Color(color: NSColor.red)
        XCTAssert(color.red == 255)
        XCTAssert(color.green == 0)
        XCTAssert(color.blue == 0)
    }
    
    func testColorLoading () {
        var color = Color()
        color.load(color: NSColor.green)
        XCTAssert(color.red == 0)
        XCTAssert(color.green == 255)
        XCTAssert(color.blue == 0)
    }
    
    func testInitPerformance() {
        self.measure {
            _ = Color()
        }
    }
    
}
