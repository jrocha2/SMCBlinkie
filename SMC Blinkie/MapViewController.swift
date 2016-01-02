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
    var adminPins = [PassengerPin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Watch Database as admin
        if AppData.sharedInstance.isAdmin {
            databaseManager.observePins()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateMap", name: currentPinsUpdateNotification, object: nil)
        }
        
        myPin.title = "My Location"
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
    
    // Students press this to place their pin and remove it
    @IBAction func pinButtonPressed(sender: UIBarButtonItem) {
        if !AppData.sharedInstance.isAdmin {
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
    
    @IBAction func leftButtonPressed(sender: AnyObject) {
        centerMapOnLocation(CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude), width: 3000, height: 750)
    }
    
    // Removes old annotations and adds updated ones
    func updateMap() {
        if AppData.sharedInstance.isAdmin {
            mapView.removeAnnotations(adminPins)
            mapView.addAnnotations(AppData.sharedInstance.currentPins)
            adminPins = AppData.sharedInstance.currentPins
        }
    }
    
    // Is called whenever mapView.addAnnotation(s) is called
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MKPointAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            // If some annotation views offscreen, dequeues to allow for reuse
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // Else it create new annotation with all relevant properties
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                if annotation.title == "My Location" {
                    view.canShowCallout = false
                    view.pinTintColor = MKPinAnnotationView.greenPinColor()
                } else {
                    view.canShowCallout = true
                    view.calloutOffset = CGPoint(x: -5, y: 5)
                    view.pinTintColor = MKPinAnnotationView.redPinColor()
                }
            }
            return view
        }
        
        return nil
    }
    
    
}
