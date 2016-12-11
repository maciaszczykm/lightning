//
//  LEDController.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 10.12.2016.
//  Copyright © 2016 Marcin Maciaszczyk. All rights reserved.
//

import Foundation
import Cocoa
import OpenGL

class LightController {
    
    let serialPort = SerialPortController(path: "/dev/cu.usbmodem1411", baudRate: 115200)
    let screen = Screen(displayId: CGMainDisplayID())
    let lights : LightStrand
    var context = CIContext()
    var magicWord: [UInt8] = Array("Ada".utf8)
    let avgFilter = CIFilter(name: "CIAreaAverage")
    
    
    init() {
        lights = LightStrand(screen: screen)
        magicWord.append(0)
        magicWord.append(25 - 1)
        magicWord.append(magicWord[3] ^ magicWord[4] ^ 0x55)
    }
    
    func captureScreen() {
        let image = CGDisplayCreateImage(screen.id)
        var data = Data(magicWord)
        for light in lights.lights {
            let crop = image?.cropping(to: light.area)
            let inputImage = CIImage(cgImage:crop!)
            avgFilter?.setValue(inputImage, forKey: kCIInputImageKey)
            avgFilter?.setValue(CIVector(cgRect: inputImage.extent), forKey: kCIInputExtentKey)
            light.color = extractColorFromCIImage(image: (avgFilter?.outputImage)!)
            data.append(light.color.red / 2)
            data.append(light.color.green / 2)
            data.append(light.color.blue / 2)
        }
        self.serialPort.send(data: data)
    }
    
    func extractColorFromCIImage(image: CIImage) -> Color {
        var pixel = Color(red: 0, green: 0, blue: 0)
        context.render(image, toBitmap: &pixel, rowBytes: 4, bounds: image.extent , format: kCIFormatRGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        return pixel
    }
    
    func NSImageFromCIImage(theCIImage: CIImage) -> NSImage {
        let rep = NSCIImageRep(ciImage:theCIImage)
        let newImage = NSImage(size: rep.size)
        newImage.addRepresentation(rep)
        return newImage
    }
    
}
