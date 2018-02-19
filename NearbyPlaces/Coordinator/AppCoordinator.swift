//
//  AppCoordinator.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 13.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit

public class AppCoordinator: NSObject, Coordinator {
    private var window: UIWindow
    
    var tabBarController: AppTabBarController
    var tabs: [TabCoordinator]
    
    init(window: UIWindow, tabBarController: AppTabBarController, tabs: [TabCoordinator]) {
        self.window = window
        self.tabBarController = tabBarController
        self.tabs = tabs
        
        super.init()
    }
    
    public func start() {
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        tabBarController.viewControllers = tabs.map { (coordinator) -> UIViewController in
            return coordinator.viewController()
        }
    }
}
