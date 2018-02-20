//
//  Persistent.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 20.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation

protocol Persistent {
    func save(with places: [JSON])
    func load()
    func clear() -> Bool
}
