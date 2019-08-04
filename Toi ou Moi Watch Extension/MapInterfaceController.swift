//
//  MapInterfaceController.swift
//  Toi ou Moi
//
//  Created by Michel Garlandat on 02/08/2019.
//  Copyright © 2019 Michel Garlandat. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation
import MapKit


class MapInterfaceController: WKInterfaceController, CLLocationManagerDelegate {
    var locationManager:CLLocationManager!
    
    var qui = "Toi"
    var updateCount = 0

    @IBOutlet weak var map: WKInterfaceMap!
    
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
        if updateCount < 3 {
            guard let location = locations.first else { return }
            // map.removeAllAnnotations()
            map.addAnnotation(location.coordinate, with: .red)
            
            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            map.setRegion(region)
        } else {
            manager.stopUpdatingLocation()
        }
    }
}
