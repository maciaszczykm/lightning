//
//  ViewController.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 10.12.2016.
//  Copyright © 2016 Marcin Maciaszczyk. All rights reserved.
//

import Cocoa
import ORSSerial

class ViewController: NSViewController {
    
    @IBOutlet weak var fpsLabel: NSTextField!
    @IBOutlet weak var powerButton: NSSegmentedControl!
    @IBOutlet weak var serialPortList: NSComboBox!
    @IBOutlet weak var portSwitch: NSPopUpButton!
    @IBOutlet weak var displaySwitch: NSPopUpButton!
    
    var controller : LightController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init port switch
        var initialPort = ""
        self.portSwitch.addItems(withTitles: SerialPortController.getAvailablePorts())
        if (portSwitch.numberOfItems > 0) {
            print("Setting " + self.portSwitch.itemTitle(at: self.portSwitch.indexOfSelectedItem) + " serial port")
            self.portSwitch.selectItem(at: 0)
            initialPort = self.portSwitch.itemTitle(at: self.portSwitch.indexOfSelectedItem)
        } else {
            print("Disabling power button, because there are not any serial ports available")
            self.powerButton.isEnabled = false
        }
        
        // Init display switch
        var initialDisplay = ""
        self.displaySwitch.addItems(withTitles: Screen.getAvailableDisplays())
        if (displaySwitch.numberOfItems > 0) {
            print("Setting " + self.displaySwitch.itemTitle(at: self.displaySwitch.indexOfSelectedItem) + " display")
            self.displaySwitch.selectItem(at: 0)
            initialDisplay = self.displaySwitch.itemTitle(at: self.displaySwitch.indexOfSelectedItem)
            if (initialDisplay.hasSuffix(Screen.mainDisplayString)) {
                initialDisplay = initialDisplay.components(separatedBy: " ").first!
            }
        } else {
            print("Disabling power button, because there are not any displays available")
            self.powerButton.isEnabled = false
        }
        
        // Initialize class members
        self.controller = LightController(serialPort: initialPort, display: UInt32(initialDisplay)!)
    }
    
    override var representedObject: Any? {
        didSet {
            // Placeholder for view initialization
        }
    }
    
    @IBAction func portSwtichPressed(_ sender: Any) {
        let chosenPort = self.portSwitch.itemTitle(at: self.portSwitch.indexOfSelectedItem)
        print("Setting \(chosenPort) serial port")
        controller?.setPort(serialPort: chosenPort)
    }
    
    @IBAction func displaySwitchPressed(_ sender: Any) {
        var chosenDisplay = self.displaySwitch.itemTitle(at: self.displaySwitch.indexOfSelectedItem)
        print("Setting \(chosenDisplay) display")
        if (chosenDisplay.hasSuffix(Screen.mainDisplayString)) {
            chosenDisplay = chosenDisplay.components(separatedBy: " ").first!
        }
        controller?.setScreen(displayId: UInt32(chosenDisplay)!)
    }
    
    @IBAction func powerButtonPressed(_ sender: Any) {
        self.disableControls()
        DispatchQueue.global(qos: .userInteractive).async {
            while (self.powerButton.selectedSegment == 1) {
                // Avoid memory leaks
                autoreleasepool() {
                    let startTime = CFAbsoluteTimeGetCurrent()
                    self.controller?.captureScreen()
                    let endTime = CFAbsoluteTimeGetCurrent()
                    DispatchQueue.main.sync {
                        let fps = Double(round(10 / (endTime - startTime))/10)
                        self.fpsLabel.stringValue = "\(fps) frames per second"
                    }
                }
            }
            DispatchQueue.main.sync {
                self.enableControls()
                self.fpsLabel.stringValue = "0 frames per second"
            }
        }
    }
    
    private func disableControls() {
        self.portSwitch.isEnabled = false
        self.displaySwitch.isEnabled = false
    }
    
    private func enableControls() {
        self.portSwitch.isEnabled = true
        self.displaySwitch.isEnabled = true
    }
    
}
