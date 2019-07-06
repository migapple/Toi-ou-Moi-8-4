//
//  CoreDataConnection.swift
//  Toi ou Moi
//
//  Created by Michel Garlandat on 01/07/2019.
//  Copyright © 2019 Michel Garlandat. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataConnection: NSObject {
    
    static let sharedInstance = CoreDataConnection()
    
    static let nomBase = "Tache"
    static let nomAppli = "ToiOuMoi"
    
    var coreData = CoreDataConnection.sharedInstance
    
    var itemsFromCoreData: [NSManagedObject] {
        
        get {
            
            var resultArray:Array<NSManagedObject>!
            let managedContext = coreData.persistentContainer.viewContext
            let fetchRequest =
                NSFetchRequest<NSManagedObject>(entityName: CoreDataConnection.nomBase)
            
            let sortDescriptor = NSSortDescriptor(key:"quand", ascending: true)
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            do {
                resultArray = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
            return resultArray
        }
        
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: CoreDataConnection.nomAppli)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Adding More Helpers
    
    func createManagedObject( entityName: String )->NSManagedObject {
        
        let managedContext =
            CoreDataConnection.sharedInstance.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        
        let item = NSManagedObject(entity: entity, insertInto: managedContext)
        
        return item
        
    }
    
    
    func saveDatabase(completion:(_ result: Bool ) -> Void) {
        
        let managedContext =
            CoreDataConnection.sharedInstance.persistentContainer.viewContext
        
        do {
            try managedContext.save()
            
            completion(true)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completion(false)
        }
        
    }
    
    func deleteManagedObject( managedObject: NSManagedObject, completion:(_ result: Bool ) -> Void) {
        
        let managedContext =
            CoreDataConnection.sharedInstance.persistentContainer.viewContext
        
        managedContext.delete(managedObject)
        
        do {
            try managedContext.save()
            
            completion(true)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completion(false)
        }
    }
}

func getContext() -> NSManagedObjectContext {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
}

func storeObject(nom: String, date: Date, quoi: String, prix: Double, libelle: String) {
    let context = getContext()
    
    let entity = NSEntityDescription.entity(forEntityName: "Tache", in: context)
    
    let managedObject = NSManagedObject(entity: entity!, insertInto: context)
    
    managedObject.setValue(nom, forKey: "qui")
    managedObject.setValue(date, forKey: "quand")
    managedObject.setValue(quoi, forKey: "quoi")
    managedObject.setValue(prix, forKey: "prix")
    managedObject.setValue(libelle, forKey: "libelle")
    
    do {
        try context.save()
        print("saved!")
    } catch {
        print(error.localizedDescription)
    }
}


