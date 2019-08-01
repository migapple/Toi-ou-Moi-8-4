//
//  AjoutViewController.swift
//  Toi ou Moi
//
//  Created by Michel Garlandat on 18/01/2017.
//  Copyright © 2017 Michel Garlandat. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import AVFoundation


protocol AjoutViewControllerDelegate {
    func myVCDidFinish(controller:AjoutViewController)
}

class AjoutViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var quiLabelField: UILabel!
    @IBOutlet weak var quoiLabelField: UILabel!
    @IBOutlet weak var dateLabelField: UILabel!
    @IBOutlet weak var prixLabelField: UILabel!
    @IBOutlet weak var prixTextField: UITextField!
    @IBOutlet weak var monDatePicker: UIDatePicker!
    @IBOutlet weak var activitePicker: UIPickerView!
    @IBOutlet weak var quiSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ajouterButton: UIButton!
    @IBOutlet weak var libelleTextField: UITextField!
    @IBOutlet weak var AjouterUiBarButton: UIBarButtonItem!
    @IBOutlet weak var finButton: UIButton!
    @IBOutlet weak var carte: MKMapView!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lngLabel: UILabel!
    
    // récupéré de ViewController
    var selection:Int?
    var delegate:AjoutViewControllerDelegate? = nil
    var tache:Tache?
    
    var rester = false
    var choix = "Restau"
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var qui = "Toi"
    let numberFormatter = NumberFormatter()
    let activite = readSetUp()
    var lat:CLLocationDegrees?
    var lng:CLLocationDegrees?
    var latDouble: Double = 0
    var lngDouble: Double = 0
    
    //geolocalisation
    var locationManager:CLLocationManager = CLLocationManager()
    var positionUtilisateur:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //geolocalisation
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        carte.showsUserLocation = true
        carte.userLocation.title = "Maison"
        carte.userLocation.subtitle = "Location"
        
        // centre sur position utilisateur
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
        carte.setRegion(region, animated: true)
        
        let activite = readSetUp()
        
        // on donne la main à la vue sur activitePicker
        activitePicker.delegate = self
        quiSegmentedControl.setTitle(activite.toi, forSegmentAt: 0)
        quiSegmentedControl.setTitle(activite.moi, forSegmentAt: 1)

        monDatePicker.locale = Locale(identifier: "fr_FR")

        // on donne la main au champ prix
        // prixTextField.becomeFirstResponder()
        
        //activitepicker reprend la selection de ViewController
        activitePicker.selectRow(selection!, inComponent: 0, animated: false)

//        NotificationCenter.default.addObserver(forName: Notification.Name("weGotInfo"), object: nil, queue: nil) { (notification) in
//            DispatchQueue.main.async {
//                print("weGotInfo")
//            }
//        }
        
        if isEditing {
            self.title = "Modification"
            afficheDate()
            AjouterUiBarButton.title = "Modification"
            resterSwitch.isHidden = true
            finButton.isHidden = true
            print(tache!)
            affiche(tache: tache!)
            annotation()
        } else {
            self.title = "Ajout"
            afficheDate()
             // Sélection Moi pour ces sélections
            if selection == 1 || selection == 3 {
                quiSegmentedControl.selectedSegmentIndex = 1
                qui = "Moi"
            }
            quoiLabelField.text = activite.activites![selection!]
       }
     }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        positionUtilisateur = locations[0]
        lat = positionUtilisateur?.coordinate.latitude
        lng = positionUtilisateur?.coordinate.longitude
        var location: CLLocationCoordinate2D?
        
        if isEditing {
            latLabel.text = "\(tache?.lat ?? 0)"
            lngLabel.text = "\(tache?.lng ?? 0)"
        } else {
            latLabel.text = "\(lat!)"
            lngLabel.text = "\(lng!)"
            
            // Transfert vers Apple Watch
            
//            Session.default.transferUserInfo(["lat": lat!, "lng": lng])
            
        }
    
        let latDelta:CLLocationDegrees = 0.05
        let lngDelta:CLLocationDegrees = 0.05
        
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lngDelta)
        
        if isEditing {
            location = CLLocationCoordinate2DMake(tache?.lat ?? 0, tache?.lng ?? 0)
        } else {
            location = CLLocationCoordinate2DMake(lat!, lng!)
        }
        
        let region:MKCoordinateRegion = MKCoordinateRegion(center: location!, span: span)
        
        carte.setRegion(region, animated: true)
    }
    
    func annotation() {
        carte.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let coordinate = CLLocationCoordinate2D(latitude: tache!.lat, longitude: tache!.lng)
        let annotation = Annotation(coordinate: coordinate, title: tache?.libelle, subtitle: "")
        carte.addAnnotation(annotation)
        //let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
        
        carte.setRegion(annotation.region, animated: true)
        
    }
    
    final class Annotation: NSObject, MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        var title: String?
        var subtitle: String?
        
        init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
            
            super.init()
        }
        
        var region: MKCoordinateRegion {
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            return MKCoordinateRegion(center: coordinate, span: span)
        }
    }
    
    func affiche(tache: Tache)  {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        quiLabelField.text = tache.qui
        dateLabelField.text = dateFormatter.string(from: tache.quand!)
        monDatePicker.date = tache.quand!
        quoiLabelField.text = tache.quoi
        let prix = NSString(format:"%.2f", tache.prix) as String
        let prix2 = prix.replacingOccurrences(of: ".", with: ",")
        prixLabelField.text = prix2
        prixTextField.text = prix2
        libelleTextField.text = tache.libelle
        if tache.qui == "Toi" {
            quiSegmentedControl.selectedSegmentIndex = 0
        } else {
            quiSegmentedControl.selectedSegmentIndex = 1
        }
     }

    @IBAction func Fin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fermeClavier(_ sender: Any) {
        prixTextField.resignFirstResponder()
    }
    
    @IBOutlet weak var resterSwitch: UISwitch!
    
    @IBAction func resterSwitchEtat(_ sender: Any) {
        if resterSwitch.isOn {
            rester = true
        } else {
            rester = false
        }
    }
    
    @IBAction func modiferDatePicker(_ sender: Any) {
        dateLabelField.text = dateFormatter.string(for: monDatePicker.date)
    }
    
    @IBAction func quiSegmentedControlAction(_ sender: Any) {
        switch quiSegmentedControl.selectedSegmentIndex
        {
        case 0:
            qui = "Toi";
            quiLabelField.text = "Toi"
        case 1:
            qui = "Moi";
            quiLabelField.text = "Moi"
        default:
            break;
        }
    }
    
    @IBAction func ajouterAction(_ sender: Any) {
        
        if prixTextField.text == "" {
            prixTextField.text = "0"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let maDate:Date = dateFormatter.date(from: dateLabelField.text!)!
        numberFormatter.locale = Locale(identifier: "fr_FR")
        let prixDouble = numberFormatter.number(from: prixTextField.text!) as! Double
        
        if isEditing {
            numberFormatter.locale = Locale(identifier: "en_EN")
            latDouble = numberFormatter.number(from: latLabel.text ?? "0.0") as! Double
            lngDouble = numberFormatter.number(from: lngLabel.text ?? "0.0") as! Double
            
        } else {
            latDouble = Double(lat!)
            lngDouble = Double(lng!)
        }
        
        numberFormatter.locale = Locale(identifier: "en_EN")
        
        if isEditing {
            tache!.qui = quiLabelField.text
            tache!.quoi = quoiLabelField.text!
            tache!.quand = maDate
            tache!.prix = prixDouble
            tache!.libelle = libelleTextField.text
            tache!.lat = latDouble
            tache!.lng = lngDouble
            
        } else {
            storeObject(nom: qui, date: maDate, quoi: quoiLabelField.text!, prix: prixDouble, libelle: libelleTextField.text!, lat: latDouble, lng: lngDouble)
         }
        
        quiLabelField.text = qui
        prixLabelField.text = prixTextField.text
        prixTextField.text = ""
        libelleTextField.text = ""
        // prixTextField.becomeFirstResponder()


        // On revient à la vue précédente
        if rester == false {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func annulerAction(_ sender: Any) {
        if rester == false {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK - Gestion Activites Picker View
     public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activite.activites![row]
     }
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activite.activites!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choix = activite.activites![row]
        quoiLabelField.text = choix
    }
    
    func afficheDate() {
        // affiche la date du jour et le met dans le champ dateTextField
        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale
        // dateFormatter.dateFormat = "EEE dd/MM/yy HH:mm"
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
        dateLabelField.text = dateFormatter.string(from: monDatePicker.date)
    }
    
    func doubleClic(_ sender: UIButton, event: UIEvent) {
        let touch: UITouch = event.allTouches!.first!
        if (touch.tapCount == 2) {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
