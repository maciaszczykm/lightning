//
//  SerialPort.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 10.12.2016.
//  Copyright © 2016 Marcin Maciaszczyk. All rights reserved.
//

import Foundation
import ORSSerial

class SerialPort {
    
    let serialPort: ORSSerialPort
    let magicWord: Data
    
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
        NSLog("Getting list of available ports")
        var ports = [String]()
        for port in ORSSerialPortManager.shared().availablePorts {
            ports.append("/dev/cu." + port.name)
        }
        NSLog("Available ports: \(ports)")
        return ports
    }
    
}
