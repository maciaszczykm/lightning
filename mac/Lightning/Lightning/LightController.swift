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
    
    let serialPortController : SerialPortController
    let lights : LightStrand
    let screen : Screen
    let context : CIContext
    let filter : CIFilter
    
    init(serialPort: String) {
        self.screen = Screen(displayId: CGMainDisplayID())
        self.lights = LightStrand(screen: screen)
        
        // Generate magic word (11 bytes-long)
        var magicWord: [UInt8] = Array("Lightning".utf8)
        magicWord.append(UInt8(lights.lights.count - 1))
        magicWord.append(magicWord[magicWord.count - 1] ^ 0x13)
        
        self.serialPortController = SerialPortController(path: serialPort, baudRate: 115200, magicWord: Data(magicWord))
        self.context = CIContext()
        self.filter = CIFilter(name: "CIAreaAverage")!
    }
    
    func captureScreen() {
        let image = CGDisplayCreateImage(screen.id)
        var data = Data()
        for light in lights.lights {
            let crop = image?.cropping(to: light.area)
            let inputImage = CIImage(cgImage:crop!)
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            filter.setValue(CIVector(cgRect: inputImage.extent), forKey: kCIInputExtentKey)
            light.color = extractColor(image: (filter.outputImage)!)
            data.append(light.color.red / 2)
            data.append(light.color.green / 2)
            data.append(light.color.blue / 2)
        }
        self.serialPortController.send(data: data)
    }
    
    func extractColor(image: CIImage) -> Color {
        var pixel = Color(red: 0, green: 0, blue: 0)
        context.render(image, toBitmap: &pixel, rowBytes: 4, bounds: image.extent , format: kCIFormatRGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        return pixel
    }

}
