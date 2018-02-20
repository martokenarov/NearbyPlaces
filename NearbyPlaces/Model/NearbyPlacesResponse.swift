//
//  NearbyPlacesResponse.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 15.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation

// Places response
private var nextPageTokenKey = "next_page_token"
private var statusKey = "status"
private var resultsKey = "results"

struct NearbyPlacesResponse {
    var nextPageToken: String?
    var status: String  = "NOK"
    var places: [JSON]?
    
    init?(dic:JSON?) {
        nextPageToken = dic?[nextPageTokenKey] as? String
        
        if let status = dic?[statusKey] as? String {
            self.status = status
        }
        
        if let results = dic?[resultsKey] as? [[String : Any]]{
            var places = [JSON]()
            for place in results {
                places.append(place)
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
