//
//  Place+CoreDataProperties.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 20.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var placeId: String?
    @NSManaged public var name: String?
    @NSManaged public var vicinity: String?
    @NSManaged public var isOpen: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}
