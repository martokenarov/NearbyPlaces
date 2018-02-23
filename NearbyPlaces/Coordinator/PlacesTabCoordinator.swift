//
//  PlacesTabCoordinator.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 13.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit
import CoreLocation

class PlacesTabCoordinator: TabCoordinator {
    var rootController: UIViewController
    var tabBarItem: UITabBarItem = UITabBarItem(title: "Places", image: UIImage(named: "Place"), tag: 0)
    
    var places:[Place] = [Place]()
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    init() {
        let placesTableViewViewModel = PlacesTableViewViewModel(with: PersistentCoreData(with: CoreDataStack.sharedInstance))
        
        let placesVC = PlacesTableViewController(with: placesTableViewViewModel)
        placesVC.tabBarItem = tabBarItem
        placesVC.view.backgroundColor = UIColor.clear
        rootController = placesVC
        rootController.tabBarItem = tabBarItem
    }
    
    func viewController() -> UIViewController {
        return rootController
    }
}


