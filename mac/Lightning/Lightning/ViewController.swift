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
    
    var controller : LightController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPortSwitch()
    }
    
    override var representedObject: Any? {
        didSet {
            // Placeholder for view initialization
        }
    }
    
    private func initPortSwitch() {
        self.portSwitch.addItems(withTitles: SerialPortController.getAvailablePorts())
        if (portSwitch.numberOfItems > 0) {
            print("Setting " + self.portSwitch.itemTitle(at: self.portSwitch.indexOfSelectedItem) + " serial port")
            self.portSwitch.selectItem(at: 0)
            self.controller = LightController(serialPort: self.portSwitch.itemTitle(at: self.portSwitch.indexOfSelectedItem))
        } else {
            print("Disabling power button, because there are not any serial ports available")
            self.powerButton.isEnabled = false
        }
    }
    
    @IBAction func portSwtichPressed(_ sender: Any) {
        print("Setting " + self.portSwitch.itemTitle(at: self.portSwitch.indexOfSelectedItem) + " serial port")
        self.controller = LightController(serialPort: self.portSwitch.itemTitle(at: self.portSwitch.indexOfSelectedItem))
    }
    
    @IBAction func powerButtonPressed(_ sender: Any) {
        self.disableControls()
        DispatchQueue.global(qos: .background).async {
            while (self.powerButton.selectedSegment == 1) {
                // Avoid memory leaks
                autoreleasepool() {
                    let startTime = CFAbsoluteTimeGetCurrent()
                    self.controller?.captureScreen()
                    let endTime = CFAbsoluteTimeGetCurrent()
                    DispatchQueue.main.sync {
                        self.fpsLabel.stringValue = "\(1.0 / (endTime - startTime))"
                    }
                }
            }
            DispatchQueue.main.sync {
                self.enableControls()
                self.fpsLabel.stringValue = "-"
            }
        }
    }
    
    private func disableControls() {
        self.portSwitch.isEnabled = false
    }
    
    private func enableControls() {
        self.portSwitch.isEnabled = true
    }
    
}
