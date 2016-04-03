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
    var blinkieMarker = MKPointAnnotation()
    
    var pinPlaced = false
    var adminPins = [PassengerPin]()
    var myLastLocation = CLLocationCoordinate2D()
    var myPinRadius = CLCircularRegion()
    var pinTimer = NSTimer()
    var recentPins = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    
        // Watch Database as admin
        if AppData.sharedInstance.isAdmin {
            databaseManager.observePins()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.updateStudentPins), name: currentPinsUpdateNotification, object: nil)
            myLastLocation = mapView.userLocation.coordinate
            databaseManager.setBlinkieLocation(myLastLocation)
            
            // This timer updates the Blinkie's coordinates in the database every 10 seconds as of now
            let _ = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(MapViewController.updateBlinkieLocation), userInfo: nil, repeats: true)
        } else {
            databaseManager.observeBlinkieLocation()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.updateBlinkieMarker), name: blinkieUpdateNotification, object: nil)
            let _ = NSTimer.scheduledTimerWithTimeInterval(90, target: self, selector: #selector(MapViewController.decrementRecentPins), userInfo: nil, repeats: true)
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
    
    // Leaves mapview and the authViewController signs out of Google
    @IBAction func signOutPressed(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // Students press this to place their pin and remove it
    // Admins press this button to ...
    @IBAction func pinButtonPressed(sender: UIBarButtonItem) {
        if !AppData.sharedInstance.isAdmin {
            if !pinPlaced {
                if isInNDArea() && recentPins < 5 {
                    myPin.coordinate = CLLocationCoordinate2D(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
                    myPinRadius = CLCircularRegion(center: myPin.coordinate, radius: 45, identifier: "pinRadius")
                    pinTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(MapViewController.checkPinDistance), userInfo: nil, repeats: true)
                    mapView.addAnnotation(myPin)
                    databaseManager.addPinToDatabase(mapView.userLocation.coordinate)
                    pinPlaced = true
                    recentPins += 1
                    pinBarButton.title = "Unpin"
                }else{
                    var title = "", message = ""
                    if !isInNDArea() {
                        title = "Not In the ND/SMC Area!"
                        message = "The Blinkie does not come to this area"
                    } else {
                        title = "Don't Spam Your Location!"
                        message = "You must wait awhile before you can place your pin again"
                    }
                    
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                    
                    let confirmAction = UIAlertAction(title: "Ok",
                        style: .Default,
                        handler: { (action:UIAlertAction) -> Void in
                    })
                    
                    alert.addAction(confirmAction)
                    
                    presentViewController(alert, animated: true, completion: nil)
                }
            } else {
                pinTimer.invalidate()
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
            if annotation.title == "Blinkie" {
                let identifier = "blinkieMarker"
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.image = UIImage(named: "blinkieicon")
                return view
            } else {
                let identifier = "myPin"
                let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = false
                view.pinTintColor = MKPinAnnotationView.greenPinColor()
                return view
            }
        }
        
        return nil
    }
    
    // MARK: Student Specific Functions
    // Moves the blinkie marker on a student's view of the map
    func updateBlinkieMarker() {
        let blinkieLocation = AppData.sharedInstance.blinkieLocation
        
        if blinkieLocation.latitude == 0 && blinkieLocation.longitude == 0 {
            let alert = UIAlertController(title: "Blinkie Not Found",
                message: "Either the Blinkie isn't running or is not broadcasting its location at this time",
                preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "Ok", style: .Default)
            { (action: UIAlertAction) -> Void in }
            
            let callAction = UIAlertAction(title: "Call SMC Security", style: .Default)
            { (action: UIAlertAction) -> Void in
                if let url = NSURL(string: "tel://\(5742845000)") {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            
            alert.addAction(callAction)
            alert.addAction(confirmAction)
            presentViewController(alert, animated: true, completion: nil)
            
        } else {
            mapView.removeAnnotation(blinkieMarker)
            blinkieMarker.title = "Blinkie"
            blinkieMarker.coordinate = AppData.sharedInstance.blinkieLocation
            mapView.addAnnotation(blinkieMarker)
        }
    }
    
    // Updates recentPins on a timer so that users cannot spam pin/unpin
    func decrementRecentPins() {
        if recentPins > 0 {
            recentPins -= 1
        }
    }
    
    // Checks that the user's current location is within relevant hardcoded area
    func isInNDArea() -> Bool {
        let region = ["NW" : (41.712092, -86.263139), "NE" : (41.712092, -86.238742), "SW" : (41.701130, -86.263139), "SE" : (41.701130, -86.238742)]
        let userLat = mapView.userLocation.coordinate.latitude
        let userLon = mapView.userLocation.coordinate.longitude
        
        if userLat > region["SW"]!.0 && userLat < region["NW"]!.0 {
            if userLon > region["SW"]!.1 && userLon < region["SE"]!.1 {
                return true
            }
        }
        return false
    }
    
    // MARK: Admin Specific Functions
    // Removes old student pins and adds updated ones
    func updateStudentPins() {
        if AppData.sharedInstance.isAdmin {
            mapView.removeAnnotations(adminPins)
            mapView.addAnnotations(AppData.sharedInstance.currentPins)
            adminPins = AppData.sharedInstance.currentPins
        }
    }
    
    // Called whenever a pin's callout is selected; for admin, this callout says "Tap to Remove"
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! PassengerPin
        databaseManager.removePinFromDatabase(annotation.deviceID!)
    }
    
    // If the blinkie has moved, updates it's location in the database
    func updateBlinkieLocation() {
        if mapView.userLocation.coordinate.latitude != myLastLocation.latitude && mapView.userLocation.coordinate.longitude != myLastLocation.longitude {
            databaseManager.setBlinkieLocation(mapView.userLocation.coordinate)
            myLastLocation = mapView.userLocation.coordinate
        }
    }
    
    // Checks that the student hasn't strayed too far from their placed pin
    func checkPinDistance() {
        if !myPinRadius.containsCoordinate(mapView.userLocation.coordinate) {
            self.pinButtonPressed(UIBarButtonItem())
            
            let alert = UIAlertController(title: "Leaving Pin!",
                message: "You can remove your pin or change it to your current location",
                preferredStyle: .Alert)
            
            let changeAction = UIAlertAction(title: "Change", style: .Default,
                handler: { (action:UIAlertAction) -> Void in
                    self.pinButtonPressed(UIBarButtonItem())
            })
            
            let removeAction = UIAlertAction(title: "Remove", style: .Default,
                handler: { (action:UIAlertAction) -> Void in
            })
            
            alert.addAction(removeAction)
            alert.addAction(changeAction)
            
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    
}
