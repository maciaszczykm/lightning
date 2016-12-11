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
    let magicWord : Data
    
    init() {
        // Generate magic word
        var magicWord: [UInt8] = Array("Ada".utf8)
        magicWord.append(0)
        magicWord.append(25 - 1)
        magicWord.append(magicWord[3] ^ magicWord[4] ^ 0x55)
        
        // Initialize all class members
        self.magicWord = Data(magicWord)
        self.serialPortController = SerialPortController(path: "/dev/cu.usbmodem1411", baudRate: 115200)
        self.screen = Screen(displayId: CGMainDisplayID())
        self.lights = LightStrand(screen: screen)
        self.context = CIContext()
        self.filter = CIFilter(name: "CIAreaAverage")!
    }
    
    func captureScreen() {
        let image = CGDisplayCreateImage(screen.id)
        var data = Data(magicWord)
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
