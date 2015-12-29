//
//  AppData.swift
//  SMC Blinkie
//
//  Created by John Rocha on 12/23/15.
//  Copyright © 2015 John Rocha. All rights reserved.
//
//  Class with a shared instance of itself that can be accessed by all files

import Foundation
import MapKit

class AppData {
    static let sharedInstance = AppData()
    
    var isAdmin:Bool!
    
    // Array of hardcoded route stops
    let stops = [
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
        RouteStop(title: "Le Mans Hall",
            coordinate: CLLocationCoordinate2D(latitude: 41.707285, longitude: -86.257152)),
        
        
        RouteStop(title: "The Grotto",
            coordinate: CLLocationCoordinate2D(latitude: 41.703068, longitude: -86.240979)),
        RouteStop(title: "Library",
            coordinate: CLLocationCoordinate2D(latitude: 41.708230, longitude: -86.256315))
    ]
    
}
