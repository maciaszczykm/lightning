//
//  Screen.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 10.12.2016.
//  Copyright © 2016 Marcin Maciaszczyk. All rights reserved.
//

import Foundation

class Screen {
    
    let id : UInt32
    let resolution : CGSize
    static let mainDisplayString = " (main)"
    
    init(displayId: UInt32) {
        NSLog("Initializing \(displayId) display")
        self.id = displayId
        self.resolution = Screen.getDisplayResolution(displayId: displayId)
    }
    
    static func getAvailableDisplays() -> [String] {
        NSLog("Getting list of available displays")
        let maxCount: UInt32 = 16
        var realCount: UInt32 = 0
        var availableDisplays = [CGDirectDisplayID](repeating: 0, count: Int(maxCount))
        CGGetOnlineDisplayList(maxCount, &availableDisplays, &realCount)
        var displays = [String]()
        for display in Array(availableDisplays[0..<Int(realCount)]) {
            var stringValue = String(display)
            if (CGDisplayIsMain(display) == 1) {
                stringValue += mainDisplayString
            }
            displays.append(stringValue)
        }
        NSLog("Available displays: \(displays)")
        return displays
    }
    
    static func getDisplayResolution(displayId: CGDirectDisplayID) -> CGSize {
        NSLog("Getting resolution of \(displayId) display")
        let displayedImage = CGDisplayCreateImage(displayId)
        let displaySize = CGSize(width: (displayedImage?.width)!, height: (displayedImage?.height)!)
        NSLog("Resolution of \(displayId) display: \(displaySize.width)x\(displaySize.height)")
        return displaySize
    }
    
}
