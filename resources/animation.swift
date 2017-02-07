import Foundation

class Disco: LightController, Animation {
    
    private var state = 0
    
    func setup(colors: [Color]) {
        for light in self.lights.lights {
            light.color = colors[state]
        }
        self.proceed()
    }
    
    func run(colors: [Color]) {
        for light in self.lights.lights {
            light.color = colors[self.state]
        }
        self.proceed()
        self.serialPort.send(lights: lights)
    }
    
    func proceed() {
        if state < 3 {
            self.state += 1
        } else {
            self.state = 0
        }
    }
    
}
