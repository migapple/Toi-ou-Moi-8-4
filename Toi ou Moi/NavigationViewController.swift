//
//  NavigationViewController.swift
//  Toi ou Moi
//
//  Created by Michel Garlandat on 28/08/2019.
//  Copyright © 2019 Michel Garlandat. All rights reserved.
//

import UIKit
import MapKit


class NavigationViewController: UIViewController {
    @IBOutlet weak var carte: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        
//        var locationManager:CLLocationManager = CLLocationManager()
//        var positionUtilisateur:CLLocation?
//
//        locationManager.delegate = self as! CLLocationManagerDelegate
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        carte.showsUserLocation = true
        carte.userLocation.title = "Maison"
        carte.userLocation.subtitle = "Location"
        carte.showsUserLocation = true
        carte.userLocation.title = "Maison"
        carte.userLocation.subtitle = "Location"
        
//        // centre sur position utilisateur
//        guard let coordinate = locationManager.location?.coordinate else { return }
//        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
//        carte.setRegion(region, animated: true)
//
        
    }
    
    @IBAction func GoTapped(_ sender: Any) {
        let latitude = 48.7788
        let longitude = 2.2872
        
        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        
        let options  = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan:regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "My House"
        mapItem.openInMaps(launchOptions: options)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
