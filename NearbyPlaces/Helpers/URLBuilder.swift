//
//  URLBuilder.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 22.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import CoreLocation

let kGoogleMapsAPIBaseURL = "https://maps.googleapis.com/maps/api/"
let kGoogleSearchPath = "place/nearbysearch/json"

let kGoogleOpenMapBaseURL = "https://www.google.com/maps/search/"

let kRadius = "radius"
let kLocation = "location"
let kTypes = "types"
let kApiKey = "key"
let kGoogleApiKey = "GoogleMapsApiKey"

class URLBuilder {
    static func generateNearByPlacesUrl(for category:String, coordinates: CLLocationCoordinate2D, apiKey: Any, radius: Int) -> String {
        return kGoogleMapsAPIBaseURL + kGoogleSearchPath + "?\(kLocation)=\(coordinates.latitude),\(coordinates.longitude)&\(kRadius)=\(radius)&\(kTypes)=\(bars)&\(kApiKey)=\(apiKey)"
    }
    
    static func generateOpenMapsAppUrl(for coorfinates: CLLocationCoordinate2D) -> String {
        return "\(kGoogleOpenMapBaseURL)?api=1&query=\(coorfinates.latitude),\(coorfinates.longitude)"
    }
}
