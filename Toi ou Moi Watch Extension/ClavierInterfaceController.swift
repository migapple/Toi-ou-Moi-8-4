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
import CoreLocation

class ClavierInterfaceController: WKInterfaceController, CLLocationManagerDelegate {
    
    var display: String = ""
    var qui = ""
    var quoi = ""
    var ou = ""
    var locationManager:CLLocationManager!
    var lat:CLLocationDegrees?
    var lng:CLLocationDegrees?
    

    @IBOutlet weak var displayLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.

        guard let values = context as? [Any]  else { return }
        qui = values[0] as! String
        print(qui)
        quoi = values[1] as! String
        print(quoi)
        ou = values[2] as! String
        print(ou)
        
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

    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        let location = locations.first
        lat = location?.coordinate.latitude
        lng = location?.coordinate.longitude
    }
    
    @IBAction func toucheClear() {
        if display.count != 0 {
            display.removeLast()
            displayLabel.setText(display)
            WKInterfaceDevice.current().play(.click)
        }
    }
    
    @IBAction func touche1() {
        display.append("1")
        displayLabel.setText(display)
        WKInterfaceDevice.current().play(.click)
    }
    
    @IBAction func touche2() {
        display.append("2")
        displayLabel.setText(display)
        WKInterfaceDevice.current().play(.click)
    }
    
    @IBAction func touche3() {
        display.append("3")
        displayLabel.setText(display)
        WKInterfaceDevice.current().play(.click)
    }
    
    @IBAction func touche4() {
        display.append("4")
        displayLabel.setText(display)
        WKInterfaceDevice.current().play(.click)
    }
    
    @IBAction func touche5() {
        display.append("5")
        displayLabel.setText(display)
        WKInterfaceDevice.current().play(.click)
    }
    
    @IBAction func touche6() {
        display.append("6")
        displayLabel.setText(display)
        WKInterfaceDevice.current().play(.click)
    }
    
    @IBAction func touche7() {
        display.append("7")
        displayLabel.setText(display)
        WKInterfaceDevice.current().play(.click)
    }
    
    @IBAction func 	touche8() {
        display.append("8")
        displayLabel.setText(display)
        WKInterfaceDevice.current().play(.click)
    }
    
    @IBAction func touche9() {
        display.append("9")
        displayLabel.setText(display)
        WKInterfaceDevice.current().play(.click)
    }
    
    @IBAction func touche0() {
        display.append("0")
        displayLabel.setText(display)
        WKInterfaceDevice.current().play(.click)
    }
    
    @IBAction func toucheVirgule() {
        if !display.contains(",") {
            display.append(",")
            displayLabel.setText(display)
            WKInterfaceDevice.current().play(.click)
        }
    }
    
    @IBAction func toucheVal() {
        let date = Date()
        WCSession.default.transferUserInfo(["qui": qui, "quoi": quoi, "date": date, "display": display, "ou": ou, "lat": lat!, "lng" : lng!])
        let defaults = UserDefaults.standard
        if quoi == "Restau" {
            defaults.set(qui, forKey: "qui")
        }
        WKInterfaceDevice.current().play(.click)
        pop()
    }
}

