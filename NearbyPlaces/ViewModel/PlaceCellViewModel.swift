//
//  PlaceCellViewModel.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 15.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import CoreLocation

struct PlaceCellViewModel {
    var name: String
    var distance: Double
    var location: CLLocation?
    
    init(_ name: String, distance: Double) {
        self.name = name
        self.distance = distance
    }
}
