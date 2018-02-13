//
//  AppCoordinator.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 13.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit

public class AppCoordinator {
    
    var tabBarController: UITabBarController
    var tabs: [AnyTabCoordinator]
    
    public init(tabBarController: UITabBarController, tabs: [AnyTabCoordinator]) {
        self.tabBarController = tabBarController
        self.tabs = tabs
    }
    
    public func start() {
        tabBarController.viewControllers = tabs.map { (coordinator) -> UIViewController in
            return coordinator.rootController
        }
    }
    
}
