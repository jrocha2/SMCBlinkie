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
        
        // Hard coded annotations to be placed on map
        let arrStops = [
            RouteStop(title: "Holy Cross Hall",
                coordinate: CLLocationCoordinate2D(latitude: 41.705536, longitude: -86.259353)),
            RouteStop(title: "Regina Hall",
                coordinate: CLLocationCoordinate2D(latitude: 41.707056, longitude: -86.260225)),
            RouteStop(title: "Regina Parking Lot",
                coordinate: CLLocationCoordinate2D(latitude: 41.708021, longitude: -86.260230)),
            RouteStop(title: "Senior/Facilities Parking Lot",
                coordinate: CLLocationCoordinate2D(latitude: 41.710082, longitude: -86.258972)),
            RouteStop(title: "Angela Parking Lot",
                coordinate: CLLocationCoordinate2D(latitude: 41.710262, longitude: -86.257567)),
            RouteStop(title: "McCandless Hall",
                coordinate: CLLocationCoordinate2D(latitude: 41.708852, longitude: -86.258089)),
            RouteStop(title: "Opus Hall",
                coordinate: CLLocationCoordinate2D(latitude: 41.710505, longitude: -86.255539)),
            RouteStop(title: "The Grotto",
                coordinate: CLLocationCoordinate2D(latitude: 41.703068, longitude: -86.240979)),
            RouteStop(title: "Library",
                coordinate: CLLocationCoordinate2D(latitude: 41.708230, longitude: -86.256315)),
            RouteStop(title: "Le Mans Hall",
                coordinate: CLLocationCoordinate2D(latitude: 41.707285, longitude: -86.257152)),
        ]
        
        
        for i in arrStops {
             mapView.addAnnotation(i)
        }

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

