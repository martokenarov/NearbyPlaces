//
//  LocationManager.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 15.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import CoreLocation

typealias LocationResult = Result<CLLocationCoordinate2D, NearbyError>

protocol Location {
    var result: ((LocationResult) -> ())? { get set }
    
    func determineMyCurrentLocation()
}

class LocationManager: NSObject, CLLocationManagerDelegate, Location {
    static let shared = LocationManager()
    
    public var result: ((LocationResult) -> ())?
    
    private var locationManager:CLLocationManager?
    private var currentLocation : CLLocationCoordinate2D? {
        didSet {
            result?(.success(payload: currentLocation!))
        }
    }
    
    private override init() {}
    
    public func determineMyCurrentLocation() {
        guard currentLocation == nil else {
            return
        }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        
        debugPrint("user latitude = \(userLocation.coordinate.latitude)")
        debugPrint("user longitude = \(userLocation.coordinate.longitude)")
        
        didReceiveUserLocation(userLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("Error \(error.localizedDescription)")
        
        result?(.failure(NearbyError(title: "", description: error.localizedDescription, code: .unknownError)))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager?.startUpdatingLocation()
        case .denied, .restricted:
            // "Location access denied"
            result?(.failure(NearbyError(title: "", description: "Location access denied", code: .unknownError)))
        case .notDetermined:
            // "User should grant access to app in order to get location"
            result?(.failure(NearbyError(title: "", description: "User should grant access to app in order to get location", code: .unknownError)))
        }
    }
    
    private func didReceiveUserLocation(_ userLocation:CLLocation) {
        currentLocation = userLocation.coordinate
    }
}
