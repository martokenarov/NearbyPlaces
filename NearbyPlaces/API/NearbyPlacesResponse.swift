//
//  NearbyPlacesResponse.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 15.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation

struct NearbyPlacesResponse {
    var nextPageToken: String?
    var status: String  = "NOK"
    var places: [Place]?
    
    init?(dic:JSON?) {
        nextPageToken = dic?["next_page_token"] as? String
        
        if let status = dic?["status"] as? String {
            self.status = status
        }
        
        if let results = dic?["results"] as? [[String : Any]]{
            var places = [Place]()
            for place in results {
                if let place = Place(placeInfo: place) {
                    places.append(place)
                }
            }
            self.places = places
        }
    }
    
    func canLoadMore() -> Bool {
        if status == "OK" && nextPageToken != nil && nextPageToken?.count ?? 0 > 0 {
            return true
        }
        return false
    }
}
