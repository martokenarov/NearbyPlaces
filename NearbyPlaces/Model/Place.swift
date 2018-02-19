//
//  Place.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 15.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit
import CoreLocation

public let bars = "bar"
public let fiftyMeters = 50

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


struct Place {
    var placeId: String
    var location: CLLocationCoordinate2D?
    var name: String
    var vicinity: String?
    var isOpen: Bool?
    var types: [String]?
}

extension Place {
    init?(placeInfo:JSON) {
        guard let placeId = placeInfo["place_id"] as? String, let name = placeInfo[nameKey] as? String  else {
            return nil
        }
        
        // id
        self.placeId = placeId
        
        // name
        self.name = name
        
        // coordinates
        if let g = placeInfo[geometryKey] as? JSON {
            if let l = g[locationKey] as? [String:Double] {
                if let lat = l[latitudeKey], let lng = l[longitudeKey] {
                    location = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)
                }
            }
        }
        
        // opening hours
        if let oh = placeInfo[openingHoursKey] as? JSON {
            if let on = oh[openNowKey] as? Bool {
                isOpen = on
            }
        }
        
        // vicinity
        vicinity = placeInfo[vicinityKey] as? String
        
        // types
        types = placeInfo[typesKey] as? [String]
    }
}
