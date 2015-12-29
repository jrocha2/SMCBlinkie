//
//  RouteStop.swift
//  SMC Blinkie
//
//  Created by John Rocha on 12/28/15.
//  Copyright © 2015 John Rocha. All rights reserved.
//

import MapKit

class RouteStop: NSObject, MKAnnotation {
    
    let title:String?
    let coordinate:CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
    
    

}
