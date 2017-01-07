//
//  CaptureView.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 10.12.2016.
//  Copyright © 2016 Marcin Maciaszczyk. All rights reserved.
//

import Cocoa
import ORSSerial

class CaptureView: NSViewController {
    
    @IBOutlet weak var fpsLabel: NSTextField!
    @IBOutlet weak var powerButton: NSSegmentedControl!
    @IBOutlet weak var brightnessSlider: NSSlider!
    @IBOutlet weak var smothnessSlider: NSSlider!
    
    @IBAction func brightnessSliderMoved(_ sender: Any) {
        NSLog("Setting \(self.brightnessSlider.maxValue - self.brightnessSlider.doubleValue + self.brightnessSlider.minValue) brightness")
    }
    
    @IBAction func smothnessSliderMoved(_ sender: Any) {
        NSLog("Setting \((self.smothnessSlider.maxValue - self.smothnessSlider.doubleValue + self.smothnessSlider.minValue) / 100) smothness")
    }
    
    @IBAction func powerButtonPressed(_ sender: Any) {
        let capturer = ScreenCapturer()
        
        DispatchQueue.global(qos: .userInteractive).async {
            while (self.powerButton.selectedSegment == 1) {
                // Avoids memory leaks.
                autoreleasepool() {
                    let startTime = CFAbsoluteTimeGetCurrent()
                    capturer.capture(brightness: self.brightnessSlider.maxValue - self.brightnessSlider.doubleValue + self.brightnessSlider.minValue, smothness: (self.smothnessSlider.maxValue - self.smothnessSlider.doubleValue + self.smothnessSlider.minValue) / 100)
                    let endTime = CFAbsoluteTimeGetCurrent()
                    DispatchQueue.main.sync {
                        let fps = Double(round(10 / (endTime - startTime))/10)
                        self.fpsLabel.stringValue = "\(fps) frames per second"
                    }
                }
            }
            DispatchQueue.main.sync {
                self.fpsLabel.stringValue = "0 frames per second"
            }
        }
    }
}
