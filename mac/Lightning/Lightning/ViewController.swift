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
    
    @IBOutlet weak var resultLabel: NSTextField!
    @IBOutlet weak var switchButton: NSSegmentedControl!
    let controller = LightController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var representedObject: Any? {
        didSet {
            // Placeholder for view initialization
        }
    }
    
    @IBAction func switchButtonPressed(_ sender: Any) {
        DispatchQueue.global(qos: .utility).async {
            while (self.switchButton.selectedSegment == 1) {
                // Avoids memory leaks
                autoreleasepool() {
                    let startTime = CFAbsoluteTimeGetCurrent()
                    self.controller.captureScreen()
                    let endTime = CFAbsoluteTimeGetCurrent()
                    DispatchQueue.main.async {
                        self.resultLabel.stringValue = "\(1.0 / (endTime - startTime))"
                    }
                }
                
            }
        }
        self.resultLabel.stringValue = "-"
    }
    
}
