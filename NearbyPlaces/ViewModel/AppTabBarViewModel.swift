//
//  AppTabBarViewModel.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 22.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class AppTabBarViewModel {
    var places: [NSManagedObject]?
    var userLocation: CLLocation?
}
