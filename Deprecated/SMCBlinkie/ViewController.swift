//
//  StudentViewController.swift
//  SMCBlinkie
//
//  Created by John Rocha on 9/12/15.
//  Copyright (c) 2015 John Rocha and Jenna Wilson. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBook
import MapKit
import Firebase

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var myRoute: MKRoute?
    
    var toPass:Bool!
    var isAdmin = false
    let regionWidth: CLLocationDistance = 2200
    let regionHeight: CLLocationDistance = 1100
    var blinkieCalled = false
    
    
    func centerMapOnLocation(location: CLLocation) {
        
        // Create region of map based on center point and distances from it 
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionWidth, regionHeight)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isAdmin = toPass // Flag that identifies which user

        // Coordinates of desired corner of shown map
        let centerLocation = CLLocation(latitude: 41.703002, longitude: -86.249173)
        centerMapOnLocation(centerLocation)
        
        mapView.delegate = self       // Set ViewController as delegate of mapView
        
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

//			  // Will need to add the Grotto, but only after 11pm (potential obstacle)
//            RouteStop(title: "The Grotto",
//                coordinate: CLLocationCoordinate2D(latitude: 41.703068, longitude: -86.240979),
//                id: "theGrotto"),
//			  
//			  // Not technically on route, but might want to add
//			  // Messes up overlay - ants to go to Science Lot)
//            RouteStop(title: "Library",
//                coordinate: CLLocationCoordinate2D(latitude: 41.708230, longitude: -86.256315),
//                id: "library"),
			
			RouteStop(title: "Le Mans Hall",
                coordinate: CLLocationCoordinate2D(latitude: 41.707285, longitude: -86.257152))
        ]
		
		mapView.addAnnotations(arrStops)
		
        // Root reference to database is const
        let rootURL = "https://sweltering-fire-588.firebaseio.com/"
        let myRootRef = Firebase(url: rootURL)
        let blinkieLocation = Firebase(url: rootURL + "blinkieLocation")
        
		// Set data
		let bLoc = ["latitude": 4.999999, "longitude": -8.999999]
		blinkieLocation.setValue(bLoc)
		var bCoords = CLLocationCoordinate2D(latitude: 41.707285, longitude: -86.257152)
		let bMark = BlinkieMarker(title: "Blinkie", coordinate: bCoords)
		mapView.addAnnotation(bMark)
		
//        // Read data and react to changes
//        blinkieLocation.observeEventType(.ChildChanged, withBlock: { snapshot in
//            let bLat = snapshot.value.objectForKey("latitude") as? CLLocationDegrees
//			let bLon = snapshot.value.objectForKey("longitude") as? CLLocationDegrees
//			bCoords = CLLocationCoordinate2DMake(bLat, bLon)
//        })
		
//		// Placemarks for directions for route overlay
//		var directionsRequest = MKDirectionsRequest()
//		var placemarks = [MKMapItem]()
//		//for i in arrCoords {
//		for i in arrStops {
//			var placemark = MKPlacemark(coordinate: i.coordinate, addressDictionary: nil )
//			placemarks.append(MKMapItem(placemark: placemark))
//		}
//		
		// Get directions and add overlay
//		directionsRequest.transportType = MKDirectionsTransportType.Automobile
//		for (i, j) in placemarks.enumerate() {
//			if i < (placemarks.count - 1) {
//				directionsRequest.setSource(j)
//				directionsRequest.setDestination(placemarks[i+1])
//			} else if i == (placemarks.count - 1) {
//				directionsRequest.setSource(j)
//				directionsRequest.setDestination(placemarks[0])
//			}
//			var directions = MKDirections(request: directionsRequest)
//			directions.calculateDirectionsWithCompletionHandler {
//				(response: MKDirectionsResponse!, error: NSError!) -> Void in
//				if error == nil {
//					self.myRoute = response.routes[0] as? MKRoute
//					self.mapView.addOverlay(self.myRoute?.polyline)
//				}
//			}
//		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
	
	// Overlay renderer
//	func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
//		if overlay is MKPolyline {
//			var polylineRenderer = MKPolylineRenderer(overlay: overlay)
//			polylineRenderer.strokeColor = UIColor.blueColor()
//			polylineRenderer.lineWidth = 5
//			return polylineRenderer
//		}
//		return nil
//	}
	
    // Method called for every annotation added to the map that returns the view for the annotation
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? RouteStop {
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
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            return view
        } else if let annotation = annotation as? BlinkieMarker {
            let identifier = "marker"
            var view: MKAnnotationView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            view.image = UIImage(named: "blinkieMark")
            return view
        }
        return nil
    }
	
	func drawCircle(location: CLLocation){
		self.mapView.delegate = self
		let circle = MKCircle(centerCoordinate: location.coordinate, radius: 5)
		self.mapView.addOverlay(circle)
	}
	
//	// Overlay renderer
//	func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
//		if overlay is MKCircle {
//			var circle = MKCircleRenderer(overlay: overlay)
//			circle.strokeColor = UIColor.redColor()
//			circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
//			circle.lineWidth = 1
//			return circle
//		} else if overlay is MKPolyline {
//			var polylineRenderer = MKPolylineRenderer(overlay: overlay)
//			polylineRenderer.strokeColor = UIColor.blueColor()
//			polylineRenderer.lineWidth = 5
//			return polylineRenderer
//		}
//        
//        return nil
//	}
    
    // take annotation title and turn it into database relevant child id
    func titleToId(title: String) -> String {
        var identifier = title.lowercaseString
        identifier = title.capitalizedString
        var pieces : [String] = identifier.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "- /"))
        pieces[0] = pieces[0].lowercaseString
        var id = ""
        for piece in pieces {
            id = id + piece
        }
        return id
    }
    
    // Method called when user presses info button in an annotation callout
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
            let rootURL = "https://sweltering-fire-588.firebaseio.com/"
            let nextStop = Firebase(url: rootURL + "nextStop")
            let identifier = titleToId("\(view.annotation!.title!)")
            var url = rootURL + identifier
           
            if isAdmin {
                nextStop.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    let currentNext = "\(snapshot.value)"
                    if currentNext == view.annotation!.title! {
                        nextStop.setValue("")
                    } else {
                        nextStop.setValue(view.annotation!.title!)
                    }
                })
            } else {
                url = url + "/girlsWaiting"
                let numGirls = Firebase(url: url)
                numGirls.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    let current = Int("\(snapshot.value)")
                    if self.blinkieCalled {
                        numGirls.setValue(current!-1)
                        self.blinkieCalled = false
                    } else {
                        numGirls.setValue(current!+1)
                        self.blinkieCalled = true
                    }
                })
            }
          
    }
}


