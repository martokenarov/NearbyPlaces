//
//  PersistentCoreData.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 20.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class PersistentCoreData: NSObject, Persistent {
    private var coreData: CoreDataStack
    
    init(with coreData: CoreDataStack) {
        self.coreData = coreData
    }
    
    func load(with comletion: @escaping GetPlacesFromStorage) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
        let managedContext = coreData.persistentContainer.viewContext
        
        do {
            if let fetchedObjects = try managedContext.fetch(fetchRequest) as? [Place] {
                comletion(.success(payload:fetchedObjects))
                return
            }
            
            comletion(.failure(NearbyError(title: nil, description: "Error getting objects", code: .unknownError)))
        } catch {
            print("ERROR: \(error)")
            comletion(.failure(NearbyError(title: nil, description: error.localizedDescription, code: .unknownError)))
        }
    }
    
    func save(with places: [JSON], userLocation: CLLocation, completion: @escaping SavePlaces) {
        let context = coreData.persistentContainer.viewContext
        
        _ = places.map{Place.createPlaceEntityFrom(dictionary: $0, userLocation: userLocation, context: context)}
        
        if context.hasChanges == true {
            do {
                try context.save()
                completion(.success(payload: true))
            } catch let error {
                debugPrint("Error - \(error.localizedDescription)")
                completion(.failure(NearbyError(title: nil, description: error.localizedDescription, code: .unknownError)))
            }
        }
    }
    
    func clear(with completion: @escaping ClearDB) {
        do {
            let context = coreData.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Place.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                
                if context.hasChanges == true {
                    try context.save()
                }
                
                completion(.success(payload: true))
            } catch let error {
                debugPrint("ERROR DELETING : \(error)")
                completion(.failure(NearbyError(title: nil, description: error.localizedDescription, code: .unknownError)))
            }
        }
    }
}
