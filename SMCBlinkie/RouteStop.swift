//
//  RouteStop.swift
//  SMCBlinkie
//
//  Created by John Rocha on 9/12/15.
//  Copyright (c) 2015 John Rocha and Jenna Wilson. All rights reserved.
//
//  Object representing stops on the route with relevant data

import Foundation
import MapKit

class RouteStop: NSObject, MKAnnotation {
    let title: String
    let coordinate: CLLocationCoordinate2D
    // And any other things later like number of girls at stop?
    
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
    
    
}