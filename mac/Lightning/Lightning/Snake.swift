//
//  Snake.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 08.01.2017.
//  Copyright © 2017 Marcin Maciaszczyk. All rights reserved.
//

import Foundation

class Snake: LightController, Animation {
    
    func setup() {
        for index in 0...self.lights.lights.count - 1 {
            if index < 5 {
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
        
        var data = Data()
        for light in lights.lights {
            data.append(light.color.red)
            data.append(light.color.green)
            data.append(light.color.blue)
        }
        self.serialPort.send(data: data)
        usleep(sleepTime)
    }
    
}
