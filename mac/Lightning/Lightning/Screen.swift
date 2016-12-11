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
    
    init(displayId: UInt32) {
        self.id = displayId
        self.resolution = Screen.getDisplayResolution(displayId: displayId)
    }
    
    static func getAvailableDisplays() -> [String] {
        let maxCount: UInt32 = 16
        var realCount: UInt32 = 0
        var availableDisplays = [CGDirectDisplayID](repeating: 0, count: Int(maxCount))
        CGGetOnlineDisplayList(maxCount, &availableDisplays, &realCount)
        var displays = [String]()
        for display in Array(availableDisplays[0..<Int(realCount)]) {
            var stringValue = String(display)
            if (CGDisplayIsMain(display) == 1) {
                stringValue += " (main display)"
            }
            displays.append(stringValue)
        }
        return displays
    }
    
    static func getDisplayResolution(displayId: CGDirectDisplayID) -> CGSize {
        let displayedImage = CGDisplayCreateImage(displayId)
        return CGSize(width: (displayedImage?.width)!, height: (displayedImage?.height)!)
    }
    
}
