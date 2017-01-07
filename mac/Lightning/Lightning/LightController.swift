//
//  LightController.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 07.01.2017.
//  Copyright © 2017 Marcin Maciaszczyk. All rights reserved.
//

import Foundation
import Cocoa

class LightController {
    var serialPort: SerialPort
    var lights: LightStrand
    var screen: Screen
    let context: CIContext
    let filter: CIFilter
    
    init() {
        self.screen = Screen(id: AppConfig.sharedInstance.display)
        self.lights = LightStrand(screen: self.screen)
        self.context = CIContext()
        self.filter = CIFilter(name: "CIAreaAverage")!
        self.serialPort = SerialPort(path: AppConfig.sharedInstance.port, baudRate: 115200, useMagicWord: true)
    }
    
}
