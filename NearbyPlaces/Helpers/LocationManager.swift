//
//  LocationManager.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 15.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    public var updateLocation :((CLLocationCoordinate2D?, Error?) -> Void)?
    
    private var locationManager:CLLocationManager?
    private var currentLocation : CLLocationCoordinate2D? {
        didSet {
            updateLocation?(currentLocation, nil)
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
        debugPrint("Error \(error)")
        updateLocation?(nil, error)
        // errorGettingCurrentLocation(error.localizedDescription)
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager?.startUpdatingLocation()
        } else if status == .denied || status == .restricted {
            updateLocation?(nil, nil)
            // errorGettingCurrentLocation("Location access denied")
        }
    }
    
    func didReceiveUserLocation(_ userLocation:CLLocation) {
        currentLocation = userLocation.coordinate
    }

}
