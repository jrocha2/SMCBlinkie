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
    @IBOutlet weak var pinBarButton: UIBarButtonItem!
    
    let locationManager = CLLocationManager()
    let databaseManager = DatabaseManager(root: "https://smcblinkie.firebaseio.com")
    var myPin = MKPointAnnotation()
    var pinPlaced = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        if AppData.sharedInstance.isAdmin {
            databaseManager.observePins()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        checkLocationAuthorizationStatus()
        
        // Center map whenever the map appears
        let centerLocation = CLLocation(latitude: 41.703002, longitude: -86.249173)
        centerMapOnLocation(centerLocation, width: 3700, height: 1100)
    }
    
    // checks that user has authorized location tracking
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
            checkLocationAuthorizationStatus()
        }
    }
    
    // Centers the map on a given coordinate with provided map width and height
    func centerMapOnLocation(location: CLLocation, width: CLLocationDistance, height: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, width, height)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    
    @IBAction func pinButtonPressed(sender: UIBarButtonItem) {
        if !pinPlaced {
            myPin.coordinate = CLLocationCoordinate2D(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
            mapView.addAnnotation(myPin)
            databaseManager.addPinToDatabase(mapView.userLocation.coordinate)
            pinPlaced = true
            pinBarButton.title = "Unpin"
            
        } else {
            mapView.removeAnnotation(myPin)
            databaseManager.removePinFromDatabase()
            pinPlaced = false
            pinBarButton.title = "Pin"
        }
        
    }
    
    
}
