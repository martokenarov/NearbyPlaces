//
//  AppTabBarController.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 19.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class AppTabBarController: UITabBarController {

    private(set) var viewModel: AppTabBarViewModel
        
    init(with viewModel:AppTabBarViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
