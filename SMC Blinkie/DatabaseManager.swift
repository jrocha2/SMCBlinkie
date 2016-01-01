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

let currentPinsUpdateNotification = "com.smcblinkie.currentPinsUpdatedNotification"

class DatabaseManager {
    
    var rootStr:String!
    var rootRef:Firebase!
    var deviceRef:Firebase!
    
    init (root: String) {
        self.rootStr = root
        rootRef = Firebase(url: rootStr)
        deviceRef = rootRef.childByAppendingPath("currentPins").childByAppendingPath(UIDevice.currentDevice().identifierForVendor!.UUIDString)
    }
    
    // Used by students to add their device and location to database
    func addPinToDatabase(location: CLLocationCoordinate2D) {
        deviceRef.childByAppendingPath("latitude").setValue(location.latitude)
        deviceRef.childByAppendingPath("longitude").setValue(location.longitude)
    }
    
    // Removes the device's database entry
    func removePinFromDatabase() {
        deviceRef.removeValue()
    }
    
    // Creates observer on the database updating local pins and generating notification to update mapview accordingly
    func observePins() {
        rootRef.childByAppendingPath("currentPins").observeEventType(.Value, withBlock: { snapshot in
            var pinsComplete = true
            
            if snapshot.exists() {
                var newPins = [MKPointAnnotation]()
                for child in snapshot.children {
                    if !child.childSnapshotForPath("latitude").exists() || !child.childSnapshotForPath("longitude").exists() {
                        pinsComplete = false
                        break
                    } else {
                        let latitude = child.childSnapshotForPath("latitude").value as! CLLocationDegrees
                        let longitude = child.childSnapshotForPath("longitude").value as! CLLocationDegrees
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate.latitude = latitude
                        annotation.coordinate.longitude = longitude
                        newPins.append(annotation)
                    }
                }
                
                if pinsComplete {
                    AppData.sharedInstance.currentPins = newPins
                    NSNotificationCenter.defaultCenter().postNotificationName(currentPinsUpdateNotification, object: self)
                }
            } else {
                AppData.sharedInstance.currentPins.removeAll()
                NSNotificationCenter.defaultCenter().postNotificationName(currentPinsUpdateNotification, object: self)
            }
        })
    }
}
