//
//  MapTabCoordinator.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 13.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit

class MapTabCoordinator: TabCoordinator {
    var rootController: UIViewController
    var tabBarItem: UITabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "Map"), tag: 1)
    
    init() {
        let mapVC = MapViewController()
        mapVC.tabBarItem = tabBarItem
        mapVC.view.backgroundColor = UIColor.blue
        rootController = mapVC
        rootController.tabBarItem = tabBarItem
    }
}
