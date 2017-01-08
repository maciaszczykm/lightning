//
//  Snake.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 08.01.2017.
//  Copyright © 2017 Marcin Maciaszczyk. All rights reserved.
//

import Foundation

class Snake: LightController, Animation {
    
    private let snakeLength = 5
    
    func setup() {
        for index in 0...self.lights.lights.count - 1 {
            if index < snakeLength {
                self.lights.lights[index].color.red = 255
            } else {
                self.lights.lights[index].color.green = 255
                self.lights.lights[index].color.blue = 255
            }
        }
    }
    
    func run(sleepTime: UInt32) {
        var lastColor = lights.lights[lights.lights.count - 1].color
        for light in lights.lights {
            swap(&lastColor, &light.color)
        }
        self.serialPort.send(lights: lights)
        usleep(sleepTime)
    }
    
}
