//
//  SerialPortController.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 10.12.2016.
//  Copyright © 2016 Marcin Maciaszczyk. All rights reserved.
//

import Foundation

class SerialPortController {
    
    var serialPort : ORSSerialPort
    
    init(path: String, baudRate: NSNumber) {
        self.serialPort = ORSSerialPort(path: path)!
        self.serialPort.baudRate = baudRate
        self.serialPort.open()
    }
    
    func send(data: Data) {
        self.serialPort.send(data)
    }
    
    deinit {
        self.serialPort.close()
    }
    
}
