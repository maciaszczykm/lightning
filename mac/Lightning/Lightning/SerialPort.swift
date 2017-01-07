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
    let useMagicWord: Bool
    
    private static let magicWord = SerialPort.getMagicWord()
    
    init(path: String, baudRate: NSNumber, useMagicWord: Bool) {
        self.serialPort = ORSSerialPort(path: path)!
        self.serialPort.baudRate = baudRate
        self.serialPort.open()
        self.useMagicWord = useMagicWord
    }
    
    func send(data: Data) {
        if (self.useMagicWord) {
            var mutatedData = Data(SerialPort.magicWord)
            mutatedData.append(data)
            self.serialPort.send(mutatedData)
        } else {
            self.serialPort.send(data)
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
    
    static func getMagicWord() -> Data {
        var magicWord: [UInt8] = Array("Lightning".utf8)
        magicWord.append(25 - 1)
        magicWord.append(magicWord[magicWord.count - 1] ^ 0x13)
        return Data(magicWord)
    }
    
}


