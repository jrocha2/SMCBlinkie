//
//  MapViewController.swift
//  SMC Blinkie
//
//  Created by John Rocha on 12/23/15.
//  Copyright © 2015 John Rocha. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Center map whenever the map appears
        let centerLocation = CLLocation(latitude: 41.703002, longitude: -86.249173)
        centerMapOnLocation(centerLocation, width: 3700, height: 1100)
        
        mapView.addAnnotations(AppData.sharedInstance.stops)
    }
    
    // Centers the map on a given coordinate with provided map width and height
    func centerMapOnLocation(location: CLLocation, width: CLLocationDistance, height: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, width, height)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    // Called by the mapView when placing annotations on the map
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? RouteStop {
            let identifier = "mapPin"
            var view: MKAnnotationView
        
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.image = UIImage(named: "routestop")
            }
            
            return view
        } else {
            return nil
        }
    }

}
