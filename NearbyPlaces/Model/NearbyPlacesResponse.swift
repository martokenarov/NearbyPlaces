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
            self.places = results
        }
    }
    
    func canLoadMore() -> Bool {
        if status == "OK" && nextPageToken != nil && nextPageToken?.count ?? 0 > 0 {
            return true
        }
        return false
    }
}

extension NearbyPlacesResponse {
    
    static func parse(_ result: GetNearByPlacesResult) -> [JSON]? {
        switch result {
        case .success(let response):
            guard let places = response.places else {
                return nil
            }
            
            return places
        case .failure( _):
            
            return nil
        }
    }
}
