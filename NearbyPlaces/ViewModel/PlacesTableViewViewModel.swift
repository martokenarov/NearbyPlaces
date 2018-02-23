//
//  PlacesTableViewViewModel.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 15.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

public let bars = "bar"
public let fiveHundredMeters = 500

class PlacesTableViewViewModel {
    
    private var persistentManager: Persistent
    private var locationManager: Location
    private var apiClient: ApiClient
    
    var location: CLLocation?
    var places: [NSManagedObject]?
    
    public var onShowError: ((_ message: String) -> Void)?
    public var placeCells = Bindable([PlaceCellViewModel]())
    
    init(with persistentManager: Persistent,
         locationManager: Location,
         apiClient: ApiClient) {
        self.persistentManager = persistentManager
        self.locationManager = locationManager
        self.apiClient = apiClient
    }
    
    public func getPlaces() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            self.locationManager.result = { [weak self] result in
                
                switch(result) {
                case .success(let coordinate):
                    debugPrint("Get places for coordinate \(coordinate)")
                    
                    guard let apiKey = Bundle.main.object(forInfoDictionaryKey: kGoogleApiKey) else {
                        debugPrint("Missing google api key")
                        
                        self?.onShowError?("Something went wrong.")
                        
                        return
                    }
                    
                    let url = URLBuilder.generateNearByPlacesUrl(for: bars, coordinates: coordinate, apiKey: apiKey, radius: fiveHundredMeters)
                    
                    self?.apiClient.getNearByUserPlaces(by: url, competion: { (placesResult) in
                        debugPrint(placesResult)
                        
                        self?.location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                        
                        guard let places = NearbyPlacesResponse.parse(placesResult) else {
                            self?.onShowError?("Error parsing result")
                            return
                        }
                        
                        guard let userLocation = self?.location else {
                            self?.onShowError?("Cannot get user location")
                            return
                        }
                        
                        self?.saveData(places: places, userLocation: userLocation)
                    })
                    
                    break
                case .failure(let error):
                    debugPrint("Error - \(String(describing: error?.localizedDescription))")
                    
                    if let error = error {
                        self?.onShowError?(error.localizedDescription)
                    }
                    break
                }
            }
            
            self.locationManager.determineMyCurrentLocation()
        } else {
            loadData()
        }
    }
    
    public func openMap(for placeIndex: Int) {
        let viewModel = self.placeCells.value[placeIndex]
        
        guard let location = viewModel.location else {
            self.onShowError?("Cannot get location")
            return
        }
        
        // https://www.google.com/maps/search/?api=1&query=\(location.coordinate.latitude),\(location.coordinate.longitude)
        
        guard let url = URL(string: URLBuilder.generateOpenMapsAppUrl(for: location.coordinate)) else {
                self.onShowError?("Invalid URL scheme")
                return
        }
        
        if (UIApplication.shared.canOpenURL(url)) {
            UIApplication.shared.open(url, options: [:], completionHandler: { isOpen in
                    if !isOpen {
                        self.onShowError?("Can't open google maps")
                    }
            })
        } else {
            debugPrint("Can't use google maps")
            self.onShowError?("Can't use google maps")
        }
    }
    
    private func clear(compeltion: @escaping (Bool) -> Void) {
        persistentManager.clear { [weak self] result in
            
            switch result {
            case .success(let payload):
                
                if payload == true {
                    compeltion(payload)
                }
                
                break
            case .failure(let error):
                
                if let error = error {
                    self?.onShowError?(error.localizedDescription)
                }
                
                break
            }
        }
    }
    
    private func saveData(places: [JSON], userLocation: CLLocation) {
        self.clear { [weak self] (success) in
            self?.persistentManager.save(with: places, userLocation: userLocation, completion: { (result) in
                
                debugPrint("Core data directory: \(CoreDataStack.sharedInstance.applicationDocumentsDirectory())")
                
                switch result {
                case .success( _):
                    self?.loadData()
                    break
                case .failure(let error):
                    if let error = error {
                        debugPrint("Error: \(error.localizedDescription)")
                        
                        self?.onShowError?(error.localizedDescription)
                    }
                    break
                }
            })
        }
    }
    
    private func loadData() {
        persistentManager.load(with: { [weak self] result in
            debugPrint("result \(result)")
            switch result {
            case .success(let payload):
                debugPrint("Success - \(payload)")
                self?.populateCells(places: payload)
                break
            case .failure(let error):
                
                if let error = error {
                    debugPrint("Error: \(error.localizedDescription)")
                    
                    self?.onShowError?(error.localizedDescription)
                }
                
                break
            }
        })
    }
    
    private func populateCells(places: [NSManagedObject]) {
        self.placeCells.value = places.map({ (place) -> PlaceCellViewModel in
            
            var viewModel = PlaceCellViewModel("", distance: 0)
            
            if let name = place.value(forKey: "name") as? String {
                viewModel.name = name
            }
            
            if let latitude = place.value(forKey: "latitude") as? Double,
                let longitude = place.value(forKey: "longitude") as? Double {
                
                viewModel.location = CLLocation(latitude: latitude, longitude: longitude)
                viewModel.distance = place.value(forKey: "distance") as? Double ?? 0
            }
            
            return viewModel
        })
        
        self.places = places
    }
}


