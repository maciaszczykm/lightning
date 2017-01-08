//
//  Animations.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 08.01.2017.
//  Copyright © 2017 Marcin Maciaszczyk. All rights reserved.
//

import Foundation

class Animations {
    
    // Each animation has to be registered here.
    static var animations: [String: Animation] = ["Disco": Disco(), "Snake": Snake()]
    
    static func getAnimationNames() -> [String] {
        return Array(animations.keys)
    }
    
}
