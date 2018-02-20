//
//  PlacesTableViewViewModel.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 15.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit
import CoreLocation

public let bars = "bar"
public let fiftyMeters = 50

class PlacesTableViewViewModel {
    
    private var persistentManager: Persistent
    private var nextToken: Bindable = Bindable("")
    private var locationManager: LocationManager = LocationManager.shared
    
    var location: CLLocationCoordinate2D?
    var places: [Place]?
    
    public var onShowError: ((_ message: String) -> Void)?
    public var placeCells = Bindable([PlaceCellViewModel]())
    
    public weak var delegate:PlacesTabCoordinatorDelegate?
    
    init(with persistentManager: Persistent) {
        self.persistentManager = persistentManager
    }
    
    public func getPlaces() {
        locationManager.determineMyCurrentLocation()
        
        locationManager.locationResult = { result in
            
            switch(result) {
            case .success(let coordinate):
                debugPrint("Get places for coordinate \(coordinate)")
                
                URLSessionApiClient.getNearByUserPlaces(by: bars, coordinates: coordinate, radius: fiftyMeters, token: nil, competion: { (placesResult) in
                    debugPrint(placesResult)
                    self.location = coordinate
                    self.parse(placesResult)
                })
                
                break
            case .failure(let error):
                debugPrint("Error - \(String(describing: error?.localizedDescription))")
                
                if let error = error {
                    self.onShowError?(error.localizedDescription)
                }
                break
            }
        }
    }
    
    public func openMap(for placeIndex: Int) {
        let viewModel = self.placeCells.value[placeIndex]
        
        guard let location = viewModel.location else {
            self.onShowError?("Cannot get location")
            return
        }
        
        guard let url = URL(string:"comgooglemaps://") else {
            self.onShowError?("Invalid URL scheme")
            return
        }
        
        if (UIApplication.shared.canOpenURL(url)) {
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?saddr=&daddr=\(location.latitude),\(location.longitude)&directionsmode=driving")!)
        } else {
            debugPrint("Can't use google maps")
            self.onShowError?("Can't use google maps")
        }
    }
    
    public func endDisplayViewController() {
        guard let location = location, let places = places else {
            return
        }
        
        delegate?.didEndDisplay(userLocation: location, places: places)
    }
    
    private func parse(_ result: GetNearByPlacesResult) {
        switch result {
        case .success(let response):
            guard let places = response.places else {
                return
            }
            
            persistentManager.save(with: places)
            debugPrint("Core data directory: \(CoreDataStack.sharedInstance.applicationDocumentsDirectory())")
//            self.placeCells.value = places.map({ (place) -> PlaceCellViewModel in
//                var viewModel = PlaceCellViewModel(place.name, distance: 0)
//                viewModel.location = place.location
//
//                return viewModel
//            })
//
//            self.places = places
            break
        case .failure(let error):
            if let error = error {
                self.onShowError?(error.localizedDescription)
            }
            
            break
        }
    }
}


