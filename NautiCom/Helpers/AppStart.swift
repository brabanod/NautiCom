//
//  AppStart.swift
//  NautiCom
//
//  Created by Pascal Braband on 04.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit

class AppStart: NSObject {
    
    private static let firstAppStartKey = "isFirstAppStart"
    private static let defaults = UserDefaults.standard
    
    static public func launch() {
        if defaults.value(forKey: firstAppStartKey) as? Bool != nil {
            // If value already exists, then this is not the first app start
            defaults.set(false, forKey: firstAppStartKey)
        } else {
            // If value doesn't exist, this is the first app start
            defaults.set(true, forKey: firstAppStartKey)
        }
        defaults.synchronize()
    }
    
    
    static public func isFirstAppStart() -> Bool {
        if let firstStart = UserDefaults.standard.value(forKey: firstAppStartKey) as? Bool {
            // If value exists, return the value
            return firstStart
        } else {
            // If value doesn't exist, this is the first app start
            return true
        }
    }
    
    
    static public func reset() {
        defaults.removeObject(forKey: firstAppStartKey)
        defaults.synchronize()
    }

}
