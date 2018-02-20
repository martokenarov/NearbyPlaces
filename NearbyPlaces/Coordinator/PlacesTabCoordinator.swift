//
//  PlacesTabCoordinator.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 13.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit
import CoreLocation

protocol PlacesTabCoordinatorDelegate: class {
    func didEndDisplay(userLocation: CLLocationCoordinate2D, places: [Place])
}

class PlacesTabCoordinator: TabCoordinator {
    var rootController: UIViewController
    var tabBarItem: UITabBarItem = UITabBarItem(title: "Places", image: UIImage(named: "Place"), tag: 0)
    
    var places:[Place] = [Place]()
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    init() {
        let placesTableViewViewModel = PlacesTableViewViewModel(with: PersistentCoreData(with: CoreDataStack.sharedInstance))
        
        let placesVC = PlacesTableViewController(with: placesTableViewViewModel)
        placesVC.tabBarItem = tabBarItem
        placesVC.view.backgroundColor = UIColor.black
        rootController = placesVC
        rootController.tabBarItem = tabBarItem
        
        placesTableViewViewModel.delegate = self
    }
    
    func viewController() -> UIViewController {
        return rootController
    }
}

extension PlacesTabCoordinator: PlacesTabCoordinatorDelegate {
    func didEndDisplay(userLocation: CLLocationCoordinate2D, places: [Place]) {
        self.places = places
        self.location = userLocation
    }
}


