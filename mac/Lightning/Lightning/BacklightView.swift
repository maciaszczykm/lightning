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
    
    @IBAction func speedSliderMoved(_ sender: Any) {
        
    }
    
    @IBAction func powerButtonPressed(_ sender: Any) {
        
    }
    
    func switchControls(toState: Bool) {
        self.animiationSwitch.isEnabled = toState
        self.firstColorPicker.isEnabled = toState
        self.secondColorPicker.isEnabled = toState
        self.thirdColorPicker.isEnabled = toState
        self.fourthColorPicker.isEnabled = toState
    }
    
}
