//
//  PassengerPin.swift
//  SMC Blinkie
//
//  Created by John Rocha on 12/31/15.
//  Copyright © 2015 John Rocha. All rights reserved.
//
//  Superclass of MKAnnotation that also holds database-relevant data

import Foundation
import MapKit

class PassengerPin: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let deviceID: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D, deviceID: String) {
        self.title = title
        self.coordinate = coordinate
        self.deviceID = deviceID
        
        super.init()
    }
    
    
}


