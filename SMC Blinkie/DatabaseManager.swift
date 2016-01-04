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
let blinkieUpdateNotification = "com.smcblinkie.blinkieUpdateNotification"

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
        deviceRef.childByAppendingPath("coordinate").setValue([location.latitude, location.longitude])
    }
    
    // Removes the supplied device's entry from the database
    func removePinFromDatabase(deviceID: String) {
        let ref = rootRef.childByAppendingPath("currentPins").childByAppendingPath(deviceID)
        ref.removeValue()
    }
    
    // Creates observer on the database updating local pins and generating notification to update mapview accordingly
    func observePins() {
        rootRef.childByAppendingPath("currentPins").observeEventType(.Value, withBlock: { snapshot in
            
            if snapshot.exists() {
                var newPins = [PassengerPin]()
                for child in snapshot.children {
                    let coordArray = child.childSnapshotForPath("coordinate").value as! [CLLocationDegrees]
                    let latitude = coordArray[0]
                    let longitude = coordArray[1]
                    let deviceID = child.key!! as String
                    
                    let annotation = PassengerPin(title: "Tap to Remove", coordinate: CLLocationCoordinate2DMake(latitude, longitude), deviceID: deviceID)
                    newPins.append(annotation)
                    
                }
                AppData.sharedInstance.currentPins = newPins
                NSNotificationCenter.defaultCenter().postNotificationName(currentPinsUpdateNotification, object: self)
                
            } else {
                AppData.sharedInstance.currentPins.removeAll()
                NSNotificationCenter.defaultCenter().postNotificationName(currentPinsUpdateNotification, object: self)
            }
        })
    }
    
    // Updates blinkie location to have the given coordinates
    func setBlinkieLocation(location: CLLocationCoordinate2D) {
        let blinkieRef = rootRef.childByAppendingPath("blinkieLocation")
        blinkieRef.setValue([location.latitude, location.longitude])
    }
    
    // Creates observer on the database updating the blinkie's location and generating notification to update mapview
    func observeBlinkieLocation() {
        rootRef.childByAppendingPath("blinkieLocation").observeEventType(.Value, withBlock: { snapshot in
            
            if snapshot.exists() {
                let coordArray = snapshot.value as! [CLLocationDegrees]
                let latitude = coordArray[0]
                let longitude = coordArray[1]
                
                AppData.sharedInstance.blinkieLocation = CLLocationCoordinate2DMake(latitude, longitude)
                NSNotificationCenter.defaultCenter().postNotificationName(blinkieUpdateNotification, object: self)
            } else {
                AppData.sharedInstance.blinkieLocation = CLLocationCoordinate2DMake(0, 0)
                NSNotificationCenter.defaultCenter().postNotificationName(blinkieUpdateNotification, object: self)
            }
        })
    }
}
