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

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        let activite = readSetUp()
        
//        for index in 0..<activite.activites!.count {
////            quoiSegmentedControl.setTitle(activite.activites![index], forSegmentAt: index)
//        }
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

}
