//
//  MapViewViewModel.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 18.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import CoreLocation

class MapViewViewModel {
    private var userLocation: CLLocationCoordinate2D?
    
    public var annotationModels = Bindable([AnnotationModel]())
    public var onShowError: ((_ message: String) -> Void)?
    
    public func willDisplayMap(with places:[Place]) {
//        self.annotationModels.value = places.map({ (place) -> AnnotationModel in
//            return AnnotationModel(coordinate: place.location!, distance: 0, name: place.name)
//        })
    }
}

struct AnnotationModel {
    var coordinate: CLLocationCoordinate2D
    var distance: Int
    var name: String
}
