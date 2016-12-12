//
//  SerialPortController.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 10.12.2016.
//  Copyright © 2016 Marcin Maciaszczyk. All rights reserved.
//

import Foundation
import ORSSerial

class SerialPortController {
    
    var serialPort : ORSSerialPort
    var magicWord : Data
    
    init(path: String, baudRate: NSNumber) {
        self.serialPort = ORSSerialPort(path: path)!
        self.serialPort.baudRate = baudRate
        self.serialPort.open()
        self.magicWord = Data()
    }
    
    init(path: String, baudRate: NSNumber, magicWord: Data) {
        self.serialPort = ORSSerialPort(path: path)!
        self.serialPort.baudRate = baudRate
        self.serialPort.open()
        self.magicWord = magicWord
    }
    
    func send(data: Data) {
        if (self.magicWord.isEmpty) {
            self.serialPort.send(data)
        } else {
            var mutatedData = Data(magicWord)
            mutatedData.append(data)
            self.serialPort.send(mutatedData)
        }
    }
    
    deinit {
        self.serialPort.close()
    }
    
    static func getAvailablePorts() -> [String] {
        var availablePorts = [String]()
        for availablePort in ORSSerialPortManager.shared().availablePorts {
            availablePorts.append("/dev/cu." + availablePort.name)
        }
        return availablePorts
    }
    
}
