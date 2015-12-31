//
//  DatabaseManager.swift
//  SMC Blinkie
//
//  Created by John Rocha on 12/30/15.
//  Copyright © 2015 John Rocha. All rights reserved.
//

import Foundation
import Firebase
import MapKit

class DatabaseManager {
    
    var rootStr:String!
    var rootRef:Firebase!
    var deviceRef:Firebase!
    
    init (root: String) {
        self.rootStr = root
        rootRef = Firebase(url: rootStr)
        deviceRef = rootRef.childByAppendingPath(UIDevice.currentDevice().identifierForVendor!.UUIDString)
    }
    
    func addPinToDatabase(location: CLLocationCoordinate2D) {
        deviceRef.childByAppendingPath("latitude").setValue(location.latitude)
        deviceRef.childByAppendingPath("longitude").setValue(location.longitude)
    }
    
    func removePinFromDatabase() {
        deviceRef.removeValue()
    }
}
