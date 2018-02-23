//
//  ApiClient.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 15.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import CoreLocation

enum GetNearByPlacesFailureReason: Int, Error {
    case unAuthorized = 401
    case notFound = 404
}

typealias GetNearByPlacesResult = Result<NearbyPlacesResponse, GetNearByPlacesFailureReason>
typealias GetNearByPlacesCompletion = (GetNearByPlacesResult) -> Void

protocol ApiClient {
    func getNearByUserPlaces(by url:String, competion: @escaping GetNearByPlacesCompletion)
}

