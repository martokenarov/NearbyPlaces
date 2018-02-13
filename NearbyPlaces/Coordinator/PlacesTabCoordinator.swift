//
//  PlacesTabCoordinator.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 13.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit

class PlacesTabCoordinator: TabCoordinator {
    var rootController: UIViewController
    var tabBarItem: UITabBarItem = UITabBarItem(title: "Places", image: UIImage(named: "Place"), tag: 0)
    
    init() {
        let placesVC = PlacesTableViewController()
        placesVC.tabBarItem = tabBarItem
        placesVC.view.backgroundColor = UIColor.black
        rootController = placesVC
        rootController.tabBarItem = tabBarItem
    }
}
