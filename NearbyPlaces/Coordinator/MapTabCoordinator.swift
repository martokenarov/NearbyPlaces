//
//  MapTabCoordinator.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 13.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit
import CoreLocation

class MapTabCoordinator: TabCoordinator {
    var rootController: UIViewController
    var tabBarItem: UITabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "Map"), tag: 1)
    
    init() {
        let mapVC = MapViewController(with: MapViewViewModel())
        mapVC.tabBarItem = tabBarItem
        mapVC.view.backgroundColor = UIColor.clear
        rootController = mapVC
        rootController.tabBarItem = tabBarItem
    }
    
    func viewController() -> UIViewController {
        return rootController
    }
}
