//
//  PersistentCoreData.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 20.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import CoreData

class PersistentCoreData: Persistent {
    
    private var coreData: CoreDataStack
    
    init(with coreData: CoreDataStack) {
        self.coreData = coreData
    }
    
    func save(with places: [JSON]) {
        let context = coreData.persistentContainer.viewContext
        
        _ = places.map{Place.createPlaceEntityFrom(dictionary: $0, context: context)}
        do {
            try coreData.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    func load() {
        
    }
    
    func clear() -> Bool {
        var isClear = false
        
        do {
            let context = coreData.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Place.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                coreData.saveContext()
                isClear = true
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
        
        return isClear
    }
}
