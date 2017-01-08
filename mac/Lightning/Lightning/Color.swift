//
//  Color.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 10.12.2016.
//  Copyright © 2016 Marcin Maciaszczyk. All rights reserved.
//

import Cocoa
import Foundation

// Color has to be structure containing RGBA colors, because of used API.
struct Color {
    
    var red: UInt8 = 0
    var green: UInt8 = 0
    var blue: UInt8 = 0
    var alpha: UInt8 = 0
    
    init() {
        // Placeholder.
    }
    
    init(color: NSColor) {
        self.load(color: color)
    }
    
    // Updates color with first pixel's value from specified image.
    // Brightness makes color darker (flipped logic).
    // Smothness makes color transitions longer (flipped logic).
    mutating func update(context: CIContext, image: CIImage, brightness: Double, smothness: Double) {
        let priorRed = Double(self.red)
        let priorGreen = Double(self.green)
        let priorBlue = Double(self.blue)
        
        context.render(image, toBitmap: &self, rowBytes: 4, bounds: image.extent , format: kCIFormatRGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        
        self.red = UInt8(((priorRed * (1 - smothness)) + (Double(self.red) * smothness)) / brightness)
        self.green = UInt8(((priorGreen * (1 - smothness)) + (Double(self.green) * smothness)) / brightness)
        self.blue = UInt8(((priorBlue * (1 - smothness)) + (Double(self.blue) * smothness)) / brightness)
    }
    
    mutating func load(color: NSColor) {
        self.red = UInt8(color.redComponent * 255)
        self.green = UInt8(color.greenComponent * 255)
        self.blue = UInt8(color.blueComponent * 255)
        self.alpha = UInt8(color.alphaComponent * 255)
    }
    
}
