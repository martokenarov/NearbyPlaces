//
//  MapViewController.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 13.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    private var mapView: MKMapView?
    
    public var viewModel:MapViewViewModel
    
    init(with viewModel:MapViewViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.mapView = MKMapView(frame: self.view.frame)
        
        guard let mapView = self.mapView else {
            return
        }
        
        mapView.delegate = self
        
        mapView.mapType = .standard
        self.view.addSubview(mapView)
        
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let appTabbarController = self.tabBarController as? AppTabBarController {
            viewModel.willDisplayMap(with: appTabbarController.places!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        } else {
            let pinIdent = "Pin"
            var pinView: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier:pinIdent) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                pinView = dequeuedView
            } else {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdent)
            }
            
            return pinView
        }
    }
}

extension MapViewController {
    private func bindViewModel() {

        viewModel.annotationModels.bindAndFire { [weak self] annotations in
            let mapAnnotations = annotations.map({ (annotationModel) -> MKPointAnnotation in
                let anno = MKPointAnnotation()
                anno.coordinate = annotationModel.coordinate
                anno.title = annotationModel.name
                
                return anno
            })
            
            self?.mapView?.addAnnotations(mapAnnotations)
        }
        
        viewModel.onShowError = { [weak self] message in
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
