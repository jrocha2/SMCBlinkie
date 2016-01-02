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
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        checkLocationAuthorizationStatus()
        
        // Center map whenever the map appears
        let centerLocation = CLLocation(latitude: 41.703002, longitude: -86.249173)
        centerMapOnLocation(centerLocation, width: 3700, height: 1100)
    }
    
    // Checks that user has authorized location tracking
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
                databaseManager.removePinFromDatabase(UIDevice.currentDevice().identifierForVendor!.UUIDString)
                pinPlaced = false
                pinBarButton.title = "Pin"
            }
        }
    }
    
    // Temporarily moves map to show user's current location
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
        
        // Execute the following if the pin of a passenger
        if let annotation = annotation as? PassengerPin {
            let identifier = "passengerPin"
            var view: MKPinAnnotationView
            
            // If some annotation views offscreen, dequeues to allow for reuse
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // Else it creates new annotation with all relevant properties
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.pinTintColor = MKPinAnnotationView.redPinColor()
            }
            return view
            
        // Execute the following if a point placed by the user
        } else if let annotation = annotation as? MKPointAnnotation {
            let identifier = "myPin"
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = false
            view.pinTintColor = MKPinAnnotationView.greenPinColor()
            return view
        }
        
        return nil
    }
    
    // Called whenever a pin's callout is selected; for admin, this callout says "Tap to Remove"
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! PassengerPin
        databaseManager.removePinFromDatabase(annotation.deviceID!)
    }
    
}
