//
//  MapViewViewModel.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 18.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

class MapViewViewModel {
    public var userLocation: CLLocation?
    
    public var annotationModels = Bindable([AnnotationModel]())
    public var onShowError: ((_ message: String) -> Void)?
    
    public func willDisplayMap(with places:[NSManagedObject]) {
        self.annotationModels.value = places.map({ (place) -> AnnotationModel in
            var viewModel = AnnotationModel()
            
            if let name = place.value(forKey: "name") as? String {
                viewModel.name = name
            }
            
            if let latitude = place.value(forKey: "latitude") as? Double,
                let longitude = place.value(forKey: "longitude") as? Double {
                
                viewModel.location = CLLocation(latitude: latitude, longitude: longitude)
                
                if let userLocation = self.userLocation, let placeLocation = viewModel.location {
                    viewModel.distance = placeLocation.distance(from: userLocation).rounded(toPlaces: 2)
                } else {
                    viewModel.distance = 0
                }
            }
            
            return viewModel
        })
    }
}

struct AnnotationModel {
    var location: CLLocation?
    var distance: Double?
    var name: String?
}
