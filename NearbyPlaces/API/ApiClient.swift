//
//  ApiClient.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 15.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import CoreLocation

let kGoogleMapsAPIBaseURL = "https://maps.googleapis.com/maps/api/"
let kGoogleSearchPath = "place/nearbysearch/json"

enum GetNearByPlacesFailureReason: Int, Error {
    case unAuthorized = 401
    case notFound = 404
}

typealias GetNearByPlacesResult = Result<NearbyPlacesResponse, GetNearByPlacesFailureReason>
typealias GetNearByPlacesCompletion = (GetNearByPlacesResult) -> Void

protocol ApiClient {
    static func getNearByUserPlaces(by category:String, coordinates: CLLocationCoordinate2D, radius:Int, token: String?, competion: @escaping GetNearByPlacesCompletion)
}

