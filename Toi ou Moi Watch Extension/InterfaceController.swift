//
//  InterfaceController.swift
//  Toi ou Moi Watch Extension
//
//  Created by Michel Garlandat on 23/07/2019.
//  Copyright © 2019 Michel Garlandat. All rights reserved.
//

import WatchKit
import Foundation
import CoreData

class InterfaceController: WKInterfaceController, CLLocationManagerDelegate  {
    
    @IBOutlet weak var activitePicker: WKInterfacePicker!
    @IBOutlet weak var activiteLabel: WKInterfaceLabel!
    @IBOutlet weak var toiButton: WKInterfaceButton!
    @IBOutlet weak var moiButton: WKInterfaceButton!
    
    var ou = ""
    var locationManager:CLLocationManager!
    var lat:CLLocationDegrees?
    var lng:CLLocationDegrees?
    
    
    
    class Activite {
        var toi: String?
        var moi: String?
        var activites: [String]?
        
        init(toi:String,moi:String,activites:[String]) {
            self.toi = "toi"
            self.moi = "moi"
            self.activites = activites
        }
    }
    
    var quoi = "Restau"

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        initSetup()
        let activite = readSetUp()
        
        // MARK: - Recupération notification Iphone
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "weGotInfo"), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                print("Notification venant de l'iphone")
            }
        }
        
        quiDernier()
        
        var pickerItems: [WKPickerItem] = []
        
        for index in 0..<activite.activites!.count {
            let pickerItem = WKPickerItem()
            pickerItem.title = activite.activites![index]
            pickerItems.append(pickerItem)
        }
        activitePicker.setItems(pickerItems)
        activitePicker.focus()
        activiteLabel.setText("Ou ?")
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        activiteLabel.setText("Ou ?")
        activitePicker.focus()
        
        quiDernier()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func readSetUp() -> Activite {
        
        UserDefaults.standard.register(defaults: [String : Any]())
        let userDefaults = UserDefaults.standard
        
        let activite = Activite(toi: "", moi: "", activites: [])
        
        activite.moi = userDefaults.string(forKey: "moi_0") ?? "moi"
        activite.toi = userDefaults.string(forKey: "toi_0") ?? "toi"
        
        // Set the controls to the default values.
        for index in 0...5 {
            let lactivite = "activite_\(index)"
            if let activiteSetup = userDefaults.string(forKey: lactivite) {
                activite.activites!.append(activiteSetup)
            }
        }
        return activite
    }
    
    func initSetup() {
        
        UserDefaults.standard.register(defaults: [String : Any]())
        let userDefaults = UserDefaults.standard
        
        let activite = Activite(toi: "Toi", moi: "Moi", activites: ["Restau","Courses","Essence","Perso","Vacances",""])
        
        userDefaults.set(activite.toi, forKey: "toi_0")
        userDefaults.set(activite.moi, forKey: "moi_0")
        
        for index in 0...5 {
            let lactivite = "activite_\(index)"
            userDefaults.setValue(activite.activites![index], forKey: lactivite)
        }
    }
    
    
    @IBAction func pickerAction(_ value: Int) {
        let activite = readSetUp()
        quoi = activite.activites![value]
    }
    
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        var qui = "Toi"
        if segueIdentifier == "moiSegue" {
            qui = "Moi"
        }
        
        if segueIdentifier == "toiSegue" {
            qui = "Toi"
        }
        
        return [qui, quoi, ou]
    }
    
    @IBAction func enregistrer() {
        presentTextInputController(withSuggestions: nil, allowedInputMode: .plain) { [unowned self] result in
            // 2 convert the returned item to a string if possible
            guard let result = result?.first as? String else {return}
            self.activiteLabel.setText(result)
            self.ou = result
        }
    }
    
    func quiDernier() {
        let userDefaults = UserDefaults.standard
        let qui = userDefaults.string(forKey: "qui") ?? "Moi"
        
        if qui == "Toi" {
            moiButton.setBackgroundColor(.green)
            toiButton.setBackgroundColor(.red)
        }
        
        if qui == "Moi" {
            moiButton.setBackgroundColor(.red)
            toiButton.setBackgroundColor(.green)
        }
        
    }
}
