//
//  LightStrandTests.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 08.01.2017.
//  Copyright © 2017 Marcin Maciaszczyk. All rights reserved.
//

import XCTest

@testable import Lightning

class LightStrandTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Set number of lights in strand.
        AppConfig.sharedInstance.sideLightsCount = 7
        AppConfig.sharedInstance.topLightsCount = 11
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTotalLightsCount () {
        let screen = Screen(id: 0, resolution: CGSize(width: 1280, height: 1024))
        let lights = LightStrand(screen: screen)
        XCTAssert(lights.lights.count == 25)
    }
    
    func testInitPerformance() {
        let screen = Screen(id: 0, resolution: CGSize(width: 1280, height: 1024))
        
        self.measure {
            _ = LightStrand(screen: screen)
        }
    }
    
}
