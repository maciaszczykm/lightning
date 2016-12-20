//
//  Screen.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 10.12.2016.
//  Copyright © 2016 Marcin Maciaszczyk. All rights reserved.
//

import Foundation

class Screen {
    
    let id: UInt32
    let resolution: CGSize
    
    static let mainDisplayString = " (main)"
    
    init(id: UInt32) {
        NSLog("Initializing \(id) display")
        self.id = id
        self.resolution = Screen.getDisplayResolution(id: id)
    }
    
    static func getAvailableDisplays() -> [String] {
        NSLog("Getting list of available displays")
        let maxCount: UInt32 = 16
        var realCount: UInt32 = 0
        var displaysArray = [CGDirectDisplayID](repeating: 0, count: Int(maxCount))
        CGGetOnlineDisplayList(maxCount, &displaysArray, &realCount)
        var displays = [String]()
        for display in Array(displaysArray[0..<Int(realCount)]) {
            var stringValue = String(display)
            if (CGDisplayIsMain(display) == 1) {
                stringValue += mainDisplayString
            }
            displays.append(stringValue)
        }
        NSLog("Available displays: \(displays)")
        return displays
    }
    
    static func getDisplayResolution(id: CGDirectDisplayID) -> CGSize {
        NSLog("Getting resolution of \(id) display")
        let displayedImage = CGDisplayCreateImage(id)
        let displaySize = CGSize(width: (displayedImage?.width)!, height: (displayedImage?.height)!)
        NSLog("Resolution of \(id) display: \(displaySize.width)x\(displaySize.height)")
        return displaySize
    }
    
}
