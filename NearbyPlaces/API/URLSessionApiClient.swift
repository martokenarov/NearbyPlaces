//
//  URLSessionApiClient.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 15.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import CoreLocation

class URLSessionApiClient: ApiClient {
    func getNearByUserPlaces(by url:String, competion: @escaping GetNearByPlacesCompletion) {
        
        guard let url = URL(string: url) else {
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

