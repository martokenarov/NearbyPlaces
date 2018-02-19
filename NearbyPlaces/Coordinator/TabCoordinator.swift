//
//  TabCoordinator.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 13.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import UIKit

public protocol Coordinator {
    func start()
}

public protocol TabCoordinator {
    func viewController() -> UIViewController
}
