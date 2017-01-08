//
//  ScreenCapturer.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 10.12.2016.
//  Copyright © 2016 Marcin Maciaszczyk. All rights reserved.
//

import Foundation
import Cocoa

class ScreenCapturer: LightController {
    
    func run(brightness: Double, smothness: Double) {
        let image = CGDisplayCreateImage(screen.id)
        var data = Data()
        for light in lights.lights {
            let crop = image?.cropping(to: light.area)
            let inputImage = CIImage(cgImage:crop!)
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            filter.setValue(CIVector(cgRect: inputImage.extent), forKey: kCIInputExtentKey)
            light.color.update(context: context, image: filter.outputImage!, brightness: brightness, smothness: smothness)
            data.append(light.color.red)
            data.append(light.color.green)
            data.append(light.color.blue)
        }
        self.serialPort.send(data: data)
    }
    
}
