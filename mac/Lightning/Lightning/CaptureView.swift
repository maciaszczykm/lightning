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
    
    @IBOutlet weak var displaySwitch: NSPopUpButton!
    @IBOutlet weak var brightnessSlider: NSSlider!
    @IBOutlet weak var smothnessSlider: NSSlider!
    @IBOutlet weak var resolutionLabel: NSTextField!
    @IBOutlet weak var fpsLabel: NSTextField!
    @IBOutlet weak var powerButton: NSSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize display switch.
        self.displaySwitch.addItems(withTitles: Screen.getAvailableDisplays())
        if self.displaySwitch.numberOfItems > 0 {
            AppConfig.sharedInstance.setDisplay(self.displaySwitch.itemTitle(at: 0))
            self.updateResolutionLabel()
        } else {
            AppConfig.sharedInstance.isSetupValid = false
            self.displaySwitch.isEnabled = false
        }
    }
    
    func updateResolutionLabel() {
        let resolution = Screen.getDisplayResolution(id: AppConfig.sharedInstance.display)
        self.resolutionLabel.stringValue = "\(Int(resolution.width)) × \(Int(resolution.height))"
    }
    
    @IBAction func displaySwitched(_ sender: Any) {
        AppConfig.sharedInstance.setDisplay(self.displaySwitch.itemTitle(at: self.displaySwitch.indexOfSelectedItem))
        self.updateResolutionLabel()
    }
    
    @IBAction func brightnessSliderMoved(_ sender: Any) {
        NSLog("Setting \(self.brightnessSlider.maxValue - self.brightnessSlider.doubleValue + self.brightnessSlider.minValue) brightness")
    }
    
    @IBAction func smothnessSliderMoved(_ sender: Any) {
        NSLog("Setting \((self.smothnessSlider.maxValue - self.smothnessSlider.doubleValue + self.smothnessSlider.minValue) / 100) smothness")
    }
    
    @IBAction func powerButtonPressed(_ sender: Any) {
        DispatchQueue.global(qos: .userInteractive).async {
            let capturer = ScreenCapturer()
            while self.powerButton.selectedSegment == 1 {
                // Avoids memory leaks.
                autoreleasepool() {
                    let startTime = CFAbsoluteTimeGetCurrent()
                    capturer.run(brightness: self.brightnessSlider.maxValue - self.brightnessSlider.doubleValue + self.brightnessSlider.minValue, smothness: (self.smothnessSlider.maxValue - self.smothnessSlider.doubleValue + self.smothnessSlider.minValue) / 100)
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
