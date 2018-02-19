//
//  URLSessionApiClient.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 15.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import CoreLocation

let kRadius = "radius"
let kLocation = "location"
let kTypes = "types"
let kApiKey = "key"
let kGoogleApiKey = "GoogleMapsApiKey"

class URLSessionApiClient: ApiClient {
    static func getNearByUserPlaces(by category: String, coordinates: CLLocationCoordinate2D, radius: Int, token: String?, competion: @escaping GetNearByPlacesCompletion) {
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: kGoogleApiKey) else {
            competion(.failure(nil))
            debugPrint("Missing google api key")
            return
        }
        
        let urlString = kGoogleMapsAPIBaseURL + kGoogleSearchPath + "?\(kLocation)=\(coordinates.latitude),\(coordinates.longitude)&\(kRadius)=\(radius)&\(kApiKey)=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            debugPrint("Falled to load url")
            competion(.failure(nil))
            return
        }
        
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = defaultSession.dataTask(with: url) { data, response, error in
            guard error == nil else {
                debugPrint("Error")
                return
            }
            
            guard let data = data else {
                competion(.failure(nil))
                debugPrint("No data")
                return
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? JSON) else {
                competion(.failure(nil))
                debugPrint("Invalid json")
                return
            }
            
            guard let response = NearbyPlacesResponse(dic: json) else {
                competion(.failure(nil))
                debugPrint("Cannot parse response json")
                return
            }
            
            competion(.success(payload: response))
        }
        
        dataTask.resume()
    }
}

