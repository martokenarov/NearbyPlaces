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
        
        self.view.backgroundColor = UIColor.clear
        
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
            
            if let places = appTabbarController.viewModel.places {
                viewModel.userLocation = appTabbarController.viewModel.userLocation
                viewModel.willDisplayMap(with: places)
            }
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
            
            pinView.canShowCallout = true

            return pinView
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
}

extension MapViewController {
    private func bindViewModel() {

        viewModel.annotationModels.bindAndFire { [weak self] annotations in
            let mapAnnotations = annotations.map({ (annotationModel) -> MKPointAnnotation in
                
                let anno = MKPointAnnotation()
                
                if let location = annotationModel.location {
                    anno.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                }
                
                if let name = annotationModel.name {
                    anno.title = name
                }
                
                if let distance = annotationModel.distance {
                    anno.subtitle = "\(distance)"
                }
                
                return anno
            })
            
            self?.mapView?.addAnnotations(mapAnnotations)
            
            if let userLocation = self?.viewModel.userLocation {
                let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000)
                self?.mapView?.setRegion(region, animated: true)
                self?.mapView?.showsUserLocation = true
            }
        }
        
        viewModel.onShowError = { [weak self] message in
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
