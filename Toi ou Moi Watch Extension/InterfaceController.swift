//
//  InterfaceController.swift
//  Toi ou Moi Watch Extension
//
//  Created by Michel Garlandat on 23/07/2019.
//  Copyright © 2019 Michel Garlandat. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var activitePicker: WKInterfacePicker!
    
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
        var pickerItems: [WKPickerItem] = []
        
        for index in 0..<activite.activites!.count {
            let pickerItem = WKPickerItem()
            pickerItem.title = activite.activites![index]
            pickerItems.append(pickerItem)
        }
        activitePicker.setItems(pickerItems)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
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
        
        return [qui, quoi]
    }
}
