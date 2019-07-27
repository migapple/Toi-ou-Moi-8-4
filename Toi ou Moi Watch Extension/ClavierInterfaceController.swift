//
//  ClavierInterfaceController.swift
//  Toi ou Moi Watch Extension
//
//  Created by Michel Garlandat on 24/07/2019.
//  Copyright © 2019 Michel Garlandat. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class ClavierInterfaceController: WKInterfaceController {
    
    var display: String = ""
    var qui = ""
    var quoi = ""
    

    @IBOutlet weak var displayLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.

        guard let values = context as? [Any]  else { return }
        qui = values[0] as! String
        print(qui)
        quoi = values[1] as! String
        print(quoi)
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        displayLabel.setText(display)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    @IBAction func toucheClear() {
        if display.count != 0 {
            display.removeLast()
            displayLabel.setText(display)
        }
    }
    
    @IBAction func touche1() {
        display.append("1")
        displayLabel.setText(display)
    }
    
    @IBAction func touche2() {
        display.append("2")
        displayLabel.setText(display)
    }
    
    @IBAction func touche3() {
        display.append("3")
        displayLabel.setText(display)
    }
    
    @IBAction func touche4() {
        display.append("4")
        displayLabel.setText(display)
    }
    
    @IBAction func touche5() {
        display.append("5")
        displayLabel.setText(display)
    }
    
    @IBAction func touche6() {
        display.append("6")
        displayLabel.setText(display)
    }
    
    @IBAction func touche7() {
        display.append("7")
        displayLabel.setText(display)
    }
    
    @IBAction func 	touche8() {
        display.append("8")
        displayLabel.setText(display)
    }
    
    @IBAction func touche9() {
        display.append("9")
        displayLabel.setText(display)
    }
    
    @IBAction func touche0() {
        display.append("0")
        displayLabel.setText(display)
    }
    
    @IBAction func toucheVirgule() {
        if !display.contains(",") {
            display.append(",")
            displayLabel.setText(display)
        }
    }
    
    @IBAction func toucheVal() {
        let date = Date()
        WCSession.default.transferUserInfo(["qui": qui, "quoi": quoi, "date": date, "display": display])
    }
}
