//
//  Persistent.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 20.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import CoreData

typealias DataResult = Result<[NSManagedObject], NearbyError>
typealias OperationResult = Result<Bool, NearbyError>

typealias GetPlacesFromStorage = (DataResult) -> Void
typealias SavePlaces = (OperationResult) -> Void
typealias ClearDB = (OperationResult) -> Void

protocol Persistent {
    func save(with places: [JSON], completion: @escaping SavePlaces)
    func load(with completion: @escaping GetPlacesFromStorage)
    func clear(with completion: @escaping ClearDB)
}
