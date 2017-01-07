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
        let resolution = screen.resolution
        let sideLightsCount = AppConfig.sharedInstance.sideLightsCount
        let topLightsCount = AppConfig.sharedInstance.topLightsCount
        let topLightsCountWithCorners = topLightsCount + 2
        let singleArea = CGSize(width: resolution.width / CGFloat(topLightsCountWithCorners), height: resolution.height / CGFloat(sideLightsCount))
        
        // Left bound from bottom to top (x = 0, y from max to 0).
        for i in 0...sideLightsCount - 1 {
            lights.append(Light(area: CGRect(x: 0, y: resolution.height - CGFloat(i + 1) * singleArea.height, width: singleArea.width, height: singleArea.height)))
        }
        
        // Top bound from left to the right (x from 0 to max, y = 0), corners are included in other loops.
        for i in 0...topLightsCount - 1 {
            lights.append(Light(area: CGRect(x: CGFloat(i + 1) * singleArea.width, y: 0, width: singleArea.width, height: singleArea.height)))
        }
        
        // Right bound from top to the bottom (x = max, y from 0 to max).
        for i in 0...sideLightsCount - 1 {
            lights.append(Light(area: CGRect(x: resolution.width - singleArea.width, y: CGFloat(i) * singleArea.height, width: singleArea.width, height: singleArea.height)))
        }
    }
    
}
