//
//  DatabaseManager.swift
//  SMC Blinkie
//
//  Created by John Rocha on 12/30/15.
//  Copyright © 2015 John Rocha. All rights reserved.
//

import Foundation
import Firebase

class DatabaseManager {
    
    var rootRef:String!
    
    init (root: String) {
        self.rootRef = root
    }
}
