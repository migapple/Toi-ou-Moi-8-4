//
//  ExportToCSV.swift
//  Toi ou Moi
//
//  Created by Michel Garlandat on 26/06/2019.
//  Copyright © 2019 Michel Garlandat. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension ViewController {
    
    func exportDatabase() {
        let exportString = createExportString()
        saveAndExport(exportString: exportString)
    }
    
    func saveAndExport(exportString: String) {
        let exportFilePath = NSTemporaryDirectory() + "toiOuMoi.csv"
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
        FileManager.default.createFile(atPath: exportFilePath, contents: NSData() as Data, attributes: nil)
        //var fileHandleError: NSError? = nil
        var fileHandle: FileHandle? = nil
        do {
            fileHandle = try FileHandle(forWritingTo: exportFileURL as URL)
        } catch {
            print("Error with fileHandle")
        }
        
        if fileHandle != nil {
            fileHandle!.seekToEndOfFile()
            let csvData = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            fileHandle!.write(csvData!)
            
            fileHandle!.closeFile()
            
            let firstActivityItem = NSURL(fileURLWithPath: exportFilePath)
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem], applicationActivities: nil)
            
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo
            ]
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func createExportString() -> String {
        var quiText: String = ""
        var quoiText: String = ""
        var quandText: String = ""
        var prixText: String = ""
        var libelleText: String = ""
        
        
        var export: String = NSLocalizedString("Qui, Quand, Quoi, Prix, Libelle \n", comment: "")
        for (index, itemList) in taches!.enumerated() {
            if index <= taches!.count - 1 {
                let Equi = itemList.value(forKey: "qui") as! String?
                let Equand = itemList.value(forKey: "quand") as! Date
                let Eprix = (itemList.value(forKey: "prix") as! Double?)!
                let Equoi = (itemList.value(forKey: "quoi") as! String?)!
                let Elibelle = (itemList.value(forKey: "libelle") as! String?)!
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale
                //dateFormatter.dateFormat = "EEE dd/MM/yyyy HH:mm"
                dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                quiText = Equi!
                quandText = dateFormatter.string(from: Equand)
                quoiText = Equoi
                prixText = NSString(format:"%.2f", Eprix) as String
                libelleText = Elibelle
                
                export += "\(quiText),\(quandText),\(quoiText),\(prixText),\(libelleText) \n"
            }
        }
        print("This is what the app will export: \(export)")
        return export
    }
    
    func importFile() {
        let numberFormatter = NumberFormatter()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let nouvelleActivite = NSEntityDescription.insertNewObject(forEntityName: "Tache", into: context)
        
        var dictTaches = [String:String]()
        let arrayTaches = NSMutableArray()
        var ladate:Date
        
        let importFilePath = NSTemporaryDirectory() + "toiOuMoi.csv"
        let importFileURL = NSURL(fileURLWithPath: importFilePath)
        
        let filemgr = FileManager.default
        if filemgr.fileExists(atPath: importFilePath) {
            do {
                let fullText = try String(contentsOf: importFileURL as URL, encoding: String.Encoding.utf8)
                let readings = fullText.components(separatedBy: "\n") as [String]
                
                for index in 1..<readings.count-1 {
                    let tacheData = readings[index].components(separatedBy: ",")
                    dictTaches["qui"] = "\(tacheData[0])"
                    dictTaches["quand"] = "\(tacheData[1])"
                    dictTaches["quoi"] = "\(tacheData[2])"
                    dictTaches["prix"] = "\(tacheData[3])"
                    dictTaches["libelle"] = "\(tacheData[4])"
                    print("lecture")
                    print("\(tacheData[0]) \(tacheData[1]) \(tacheData[2]) \(tacheData[3]) \(tacheData[4])" )
                    arrayTaches.add(dictTaches)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                    let maDate: Date = dateFormatter.date(from: tacheData[1])!
                    
//                    numberFormatter.locale = Locale(identifier: "fr_FR")
                    numberFormatter.locale = Locale(identifier: "en_EN")
                    let prixDouble = numberFormatter.number(from: tacheData[3]) as! Double
//                    sauvegarde(objet: nouvelleActivite, nom: tacheData[0], date: maDate, quoi: tacheData[2], prix: prixDouble, libelle: tacheData[4])
                    storeObject(nom: tacheData[0], date: maDate, quoi: tacheData[2], prix: prixDouble, libelle: tacheData[4])
                }
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
