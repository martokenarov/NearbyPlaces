//
//  PlacesTableViewController.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 13.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit

let placeCellIdentifier = "PlaceCell"

class PlacesTableViewController: UITableViewController {
    
    private var viewModel:PlacesTableViewViewModel
    
    init(with viewModel:PlacesTableViewViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = self.tabBarController {
            debugPrint("Has tabbar controller")
        }
        
        viewModel.getPlaces()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let appTabbarController = self.tabBarController as? AppTabBarController {
            appTabbarController.places = viewModel.places
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PlacesTableViewController {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.placeCells.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PlaceTableViewCell?
        
        if cell == nil {
            tableView.register(PlaceTableViewCell.classForCoder(), forCellReuseIdentifier: placeCellIdentifier)
            
            cell = PlaceTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: placeCellIdentifier)
            
        }
        
        cell?.viewModel = viewModel.placeCells.value[indexPath.row]
        
        return cell!
    }
}

extension PlacesTableViewController {
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.openMap(for: indexPath.row)
    }
}

extension PlacesTableViewController {
    func bindViewModel() {
        viewModel.placeCells.bindAndFire { [weak self] cells in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onShowError = { [weak self] message in
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            DispatchQueue.main.async {
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
}
