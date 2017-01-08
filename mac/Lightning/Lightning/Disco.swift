//
//  Disco.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 08.01.2017.
//  Copyright © 2017 Marcin Maciaszczyk. All rights reserved.
//

import Foundation

import Foundation

class Disco: LightController, Animation {
    
    private var state = 0
    
    func setup(colors: [Color]) {
        for light in self.lights.lights {
            light.color = colors[state]
        }
        self.proceed()
    }
    
    func run(colors: [Color], sleepTime: UInt32) {
        for light in self.lights.lights {
            light.color = colors[self.state]
        }
        self.proceed()
        self.serialPort.send(lights: lights)
        usleep(sleepTime)
    }
    
    func proceed() {
        if state < 3 {
            self.state += 1
        } else {
            self.state = 0
        }
    }
    
}
