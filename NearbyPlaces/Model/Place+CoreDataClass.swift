//
//  Place+CoreDataClass.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 20.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//
//

import Foundation
import CoreData

private let geometryKey = "geometry"
private let locationKey = "location"
private let latitudeKey = "lat"
private let longitudeKey = "lng"
private let nameKey = "name"
private let openingHoursKey = "opening_hours"
private let openNowKey = "open_now"
private let vicinityKey = "vicinity"
private let typesKey = "types"
private let photosKey = "photos"


@objc(Place)
public class Place: NSManagedObject {

}

extension Place {
    static func createPlaceEntityFrom(dictionary: JSON, context: NSManagedObjectContext) -> NSManagedObject? {
        
        guard let placeId = dictionary["place_id"] as? String, let name = dictionary[nameKey] as? String  else {
            return nil
        }
        
        if let placeEntity = NSEntityDescription.insertNewObject(forEntityName: "Place", into: context) as? Place {
            // id
            placeEntity.placeId = placeId
            
            // name
            placeEntity.name = name
            
            // coordinates
            if let g = dictionary[geometryKey] as? JSON {
                if let l = g[locationKey] as? [String:Double] {
                    if let lat = l[latitudeKey], let lng = l[longitudeKey] {
//                        location = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)
                        placeEntity.latitude = lat
                        placeEntity.longitude = lng
                    }
                }
            }
            
            // opening hours
            if let oh = dictionary[openingHoursKey] as? JSON {
                if let on = oh[openNowKey] as? Bool {
                    placeEntity.isOpen = on
                }
            }
            
            // vicinity
            placeEntity.vicinity = dictionary[vicinityKey] as? String
            
            return placeEntity
        }
        return nil
    }
}

