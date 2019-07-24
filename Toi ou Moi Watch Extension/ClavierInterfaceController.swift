//
//  ClavierInterfaceController.swift
//  Toi ou Moi Watch Extension
//
//  Created by Michel Garlandat on 24/07/2019.
//  Copyright © 2019 Michel Garlandat. All rights reserved.
//

import WatchKit
import Foundation


class ClavierInterfaceController: WKInterfaceController {

    @IBOutlet weak var displayLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func toucheClear() {
    }
    
    @IBAction func touche1() {
    }
    
    @IBAction func touche2() {
    }
    
    @IBAction func touche3() {
    }
    
    @IBAction func touche4() {
    }
    
    @IBAction func touche5() {
    }
    
    @IBAction func touche6() {
    }
    
    @IBAction func touche7() {
    }
    
    @IBAction func touche8() {
    }
    
    @IBAction func touche9() {
    }
    
    @IBAction func touche0() {
    }
    
    @IBAction func toucheVirgule() {
    }
    
    @IBAction func toucheVal() {
    }
}
