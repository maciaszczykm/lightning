//
//  LightController.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 10.12.2016.
//  Copyright © 2016 Marcin Maciaszczyk. All rights reserved.
//

import Foundation
import Cocoa
import OpenGL

class LightController {
    
    var serialPortController : SerialPort
    var lights : LightStrand
    var screen : Screen
    let context : CIContext
    let filter : CIFilter
    
    init(serialPort: String, display: UInt32) {
        self.screen = Screen(displayId: display)
        self.lights = LightStrand(screen: screen)
        self.context = CIContext()
        self.filter = CIFilter(name: "CIAreaAverage")!
        self.serialPortController = SerialPort(path: serialPort, baudRate: 115200, magicWord: LightController.getMagicWord())
    }
    
    func setPort(serialPort: String) {
        NSLog("Setting \(serialPort) serial port")
        self.serialPortController = SerialPort(path: serialPort, baudRate: 115200, magicWord: LightController.getMagicWord())
    }
    
    func setScreen(displayId: UInt32) {
        NSLog("Setting \(displayId) display")
        self.screen = Screen(displayId: displayId)
        self.lights = LightStrand(screen: screen)
    }
    
    func captureScreen(brightness: UInt8) {
        let image = CGDisplayCreateImage(screen.id)
        var data = Data()
        for light in lights.lights {
            let crop = image?.cropping(to: light.area)
            let inputImage = CIImage(cgImage:crop!)
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            filter.setValue(CIVector(cgRect: inputImage.extent), forKey: kCIInputExtentKey)
            light.color = extractColor(image: (filter.outputImage)!)
            data.append(light.color.red / brightness)
            data.append(light.color.green / brightness)
            data.append(light.color.blue / brightness)
        }
        self.serialPortController.send(data: data)
    }
    
    func extractColor(image: CIImage) -> Color {
        var pixel = Color(red: 0, green: 0, blue: 0)
        context.render(image, toBitmap: &pixel, rowBytes: 4, bounds: image.extent , format: kCIFormatRGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        return pixel
    }
    
    static func getMagicWord() -> Data {
        var magicWord: [UInt8] = Array("Lightning".utf8)
        magicWord.append(25 - 1)
        magicWord.append(magicWord[magicWord.count - 1] ^ 0x13)
        return Data(magicWord)
    }

}
