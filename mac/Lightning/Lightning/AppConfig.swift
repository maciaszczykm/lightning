//
//  AppConfig.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 20.12.2016.
//  Copyright © 2016 Marcin Maciaszczyk. All rights reserved.
//

import Foundation

// Singleton app configuration class.
class AppConfig {
    
    var port: String
    var display: UInt32
    var isSetupValid: Bool
    var topLightsCount, sideLightsCount: Int
    
    static let sharedInstance = AppConfig()
    
    private init() {
        self.port = ""
        self.display = 0
        self.isSetupValid = true
        self.topLightsCount = 11
        self.sideLightsCount = 7
    }
    
    func setPort(_ port: String) {
        NSLog("Setting \(port) serial port")
        self.port = port
    }
    
    func setDisplay(_ display: String) {
        NSLog("Setting \(display) display")
        if (display.hasSuffix(Screen.mainDisplayString)) {
            self.display = UInt32(display.components(separatedBy: " ").first!)!
        } else {
            self.display = UInt32(display)!
        }
    }
    
    func setTopLightsCount(_ count: String) {
        NSLog("Setting \(count) lights on top")
        self.topLightsCount = Int(count)!
    }
    
    func setSideLightsCount(_ count: String) {
        NSLog("Setting \(count) lights on both sides")
        self.sideLightsCount = Int(count)!
    }
    
}
