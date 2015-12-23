//
//  AppData.swift
//  SMC Blinkie
//
//  Created by John Rocha on 12/23/15.
//  Copyright © 2015 John Rocha. All rights reserved.
//
//  Class with a shared instance of itself that can be accessed by all files

import Foundation

class AppData {
    static let sharedInstance = AppData()
    
    var isAdmin:Bool!
    
}
