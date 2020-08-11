//
//  CoreLocation+Extension.swift
//  NautiCom
//
//  Created by Pascal Braband on 11.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D {
    
    /**
     Converts the coordinate to a readable coordinate in sexagesimal format.
     
     - returns:
     A tuple of two Strings. First string is the formatted latitude coordinate string, second ist the formatted longituted coordinate string.
     */
    func string() -> (String, String) {
        // Generate coordinate format
        var latitudeString = String(format: "%02d° ", abs(Int(self.latitude))) +
                   String(format: "%05.2f'", abs(self.latitude.truncatingRemainder(dividingBy: 1)) * 60)
        var longitudeString = String(format: "%03d° ", abs(Int(self.longitude))) +
                   String(format: "%05.2f'", abs(self.longitude.truncatingRemainder(dividingBy: 1)) * 60)
        
        // Generate correct cardinal suffix
        if self.latitude >= 0 {
            latitudeString += " N"
        } else {
            latitudeString += " S"
        }
        
        if self.longitude >= 0 {
            longitudeString += " E"
        } else {
            longitudeString += " W"
        }
        
        return (latitudeString, longitudeString)
    }
}




extension CLLocationSpeed {
    
    func toKnots() -> Double {
        // Convert m/s to knots
        if self >= 0 {
            return self * 1.94384
        } else {
            return 0
        }
    }
}
