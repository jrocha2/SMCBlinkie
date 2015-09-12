//
//  ViewController.swift
//  SMCBlinkie
//
//  Created by John Rocha on 9/12/15.
//  Copyright (c) 2015 John Rocha and Jenna Wilson. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let regionWidth: CLLocationDistance = 2200
    let regionHeight: CLLocationDistance = 1100
    
    func centerMapOnLocation(location: CLLocation) {
        
        // Create region of map based on center point and distances from it 
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionWidth, regionHeight)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Coordinates of desired corner of shown map
        let centerLocation = CLLocation(latitude: 41.703002, longitude: -86.249173)
        centerMapOnLocation(centerLocation)
        
        mapView.delegate = self     // Set ViewController as delegate of mapView
        
        // Hard coded annotations to be placed on map
        let stop01 = RouteStop(title: "The Grotto",
            coordinate: CLLocationCoordinate2D(latitude: 41.703068, longitude: -86.240979))
        let stop02 = RouteStop(title: "McCandless Hall",
            coordinate: CLLocationCoordinate2D(latitude: 41.708852, longitude: -86.258089))
        mapView.addAnnotation(stop01)
        mapView.addAnnotation(stop02)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

