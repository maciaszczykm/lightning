//
//  LightStrand.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 10.12.2016.
//  Copyright © 2016 Marcin Maciaszczyk. All rights reserved.
//

import Foundation

class LightStrand {
    
    var lights = [Light]()
    
    init(screen: Screen) {
        NSLog("Initializing light strand assuming 25 ligts in it [6 ob both sides, 11 on top and 2 in corners]")
        let resolution = screen.resolution
        let singleArea = CGSize(width: resolution.width / 13, height: resolution.height / 7)
        
        // Left bound from bottom to top (x = 0, y from max to 0).
        for i in 0...6 {
            lights.append(Light(area: CGRect(x: 0, y: resolution.height - CGFloat(i + 1) * singleArea.height, width: singleArea.width, height: singleArea.height)))
        }
        
        // Top bound from left to the right (x from 0 to max, y = 0), corners are included in other loops.
        for i in 0...10 {
            lights.append(Light(area: CGRect(x: CGFloat(i + 1) * singleArea.width, y: 0, width: singleArea.width, height: singleArea.height)))
        }
        
        // Right bound from top to the bottom (x = max, y from 0 to max).
        for i in 0...6 {
            lights.append(Light(area: CGRect(x: resolution.width - singleArea.width, y: CGFloat(i) * singleArea.height, width: singleArea.width, height: singleArea.height)))
        }
    }
    
}
