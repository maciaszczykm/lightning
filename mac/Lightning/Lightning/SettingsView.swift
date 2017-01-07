//
//  SettingsView.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 20.12.2016.
//  Copyright © 2016 Marcin Maciaszczyk. All rights reserved.
//

import Foundation
import Cocoa

class SettingsView: NSViewController {

    @IBOutlet weak var displaySwitch: NSPopUpButton!
    @IBOutlet weak var portSwitch: NSPopUpButton!
    @IBOutlet weak var topLightsField: NSTextField!
    @IBOutlet weak var leftLightsField: NSTextField!
    @IBOutlet weak var rightLightsField: NSTextField!
    @IBOutlet weak var lightsLabel: NSTextField!
    @IBOutlet weak var resolutionLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize port switch.
        self.portSwitch.addItems(withTitles: SerialPort.getAvailablePorts())
        if (self.portSwitch.numberOfItems > 0) {
            AppConfig.sharedInstance.setPort(self.portSwitch.itemTitle(at: 0))
        } else {
            AppConfig.sharedInstance.isSetupValid = false
            self.portSwitch.isEnabled = false
        }
        
        // Initialize display switch.
        self.displaySwitch.addItems(withTitles: Screen.getAvailableDisplays())
        if (self.displaySwitch.numberOfItems > 0) {
            AppConfig.sharedInstance.setDisplay(self.displaySwitch.itemTitle(at: 0))
            self.updateResolutionLabel()
        } else {
            AppConfig.sharedInstance.isSetupValid = false
            self.displaySwitch.isEnabled = false
        }
        
        // Initialize lights fields.
        self.topLightsField.stringValue = "\(AppConfig.sharedInstance.topLightsCount)"
        self.leftLightsField.stringValue = "\(AppConfig.sharedInstance.sideLightsCount)"
        self.rightLightsField.stringValue = "\(AppConfig.sharedInstance.sideLightsCount)"
        self.rightLightsField.isEnabled = false
        self.updateLightsLabel()
        
    }
    
    func updateLightsLabel() {
        var lightsCount = 0
        lightsCount += Int(self.leftLightsField.stringValue)!
        lightsCount += Int(self.rightLightsField.stringValue)!
        lightsCount += Int(self.topLightsField.stringValue)!
        self.lightsLabel.stringValue = "\(lightsCount) lights"
    }
    
    func updateResolutionLabel() {
        let resolution = Screen.getDisplayResolution(id: AppConfig.sharedInstance.display)
        self.resolutionLabel.stringValue = "\(Int(resolution.width)) × \(Int(resolution.height))"
    }
    
    @IBAction func displaySwitched(_ sender: Any) {
        AppConfig.sharedInstance.setDisplay(self.displaySwitch.itemTitle(at: self.displaySwitch.indexOfSelectedItem))
        self.updateResolutionLabel()
    }
    
    @IBAction func portSwitched(_ sender: Any) {
        AppConfig.sharedInstance.setPort(self.portSwitch.itemTitle(at: self.portSwitch.indexOfSelectedItem))
    }
    
    @IBAction func topLightsFieldChanged(_ sender: Any) {
        AppConfig.sharedInstance.setTopLightsCount(self.topLightsField.stringValue)
        self.updateLightsLabel()
    }
    
    @IBAction func leftLightsFieldChanged(_ sender: Any) {
        self.rightLightsField.stringValue = self.leftLightsField.stringValue
        AppConfig.sharedInstance.setSideLightsCount(self.leftLightsField.stringValue)
        self.updateLightsLabel()
    }
    
}