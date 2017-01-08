//
//  BacklightView.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 07.01.2017.
//  Copyright © 2017 Marcin Maciaszczyk. All rights reserved.
//

import Cocoa

class BacklightView: NSViewController {
    
    @IBOutlet weak var animiationSwitch: NSPopUpButton!
    @IBOutlet weak var speedSlider: NSSlider!
    @IBOutlet weak var firstColorPicker: NSColorWell!
    @IBOutlet weak var secondColorPicker: NSColorWell!
    @IBOutlet weak var thirdColorPicker: NSColorWell!
    @IBOutlet weak var fourthColorPicker: NSColorWell!
    @IBOutlet weak var powerButton: NSSegmentedControl!
    @IBOutlet weak var fpsLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize animiation switch.
        self.animiationSwitch.addItems(withTitles: Animations.getAnimationNames())
        if (self.animiationSwitch.numberOfItems < 1) {
            self.switchControls(toState: false)
            self.powerButton.isEnabled = false
        }
    }
    
    @IBAction func speedSliderMoved(_ sender: Any) {
        NSLog("Setting \(self.speedSlider.maxValue - self.speedSlider.doubleValue + self.speedSlider.minValue)  speed")
    }
    
    @IBAction func powerButtonPressed(_ sender: Any) {
        self.switchControls(toState: false)
        DispatchQueue.global(qos: .userInteractive).async {
            let animation = Animations.animations[self.animiationSwitch.itemTitle(at: self.animiationSwitch.indexOfSelectedItem)]!
            animation.setup()
            while (self.powerButton.selectedSegment == 1) {
                // Avoids memory leaks.
                autoreleasepool() {
                    let startTime = CFAbsoluteTimeGetCurrent()
                    animation.run(sleepTime: UInt32(self.speedSlider.maxValue - self.speedSlider.doubleValue + self.speedSlider.minValue))
                    let endTime = CFAbsoluteTimeGetCurrent()
                    DispatchQueue.main.sync {
                        let fps = Double(round(10 / (endTime - startTime))/10)
                        self.fpsLabel.stringValue = "\(fps) frames per second"
                    }
                }
            }
            DispatchQueue.main.sync {
                self.fpsLabel.stringValue = "0 frames per second"
                self.switchControls(toState: true)
            }
        }
    }
    
    func switchControls(toState: Bool) {
        self.animiationSwitch.isEnabled = toState
        self.firstColorPicker.isEnabled = toState
        self.secondColorPicker.isEnabled = toState
        self.thirdColorPicker.isEnabled = toState
        self.fourthColorPicker.isEnabled = toState
    }
    
}
