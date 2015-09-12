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
    
    let regionWidth: CLLocationDistance = 2000
    let regionHeight: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        
        // Create region of map based on center point and distances from it 
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionWidth, regionHeight)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hard coded coordinates of desired corner of shown map
        let centerLocation = CLLocation(latitude: 41.703002, longitude: -86.250173)
        centerMapOnLocation(centerLocation)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

