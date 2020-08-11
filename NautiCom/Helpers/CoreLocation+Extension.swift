//
//  CoreLocation+Extension.swift
//  NautiCom
//
//  Created by Pascal Braband on 11.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit
import CoreLocation

extension CLLocationCoordinate2D {
    
    func string() -> (String, String) {
        var latitudeString = String(format: "%02d° ", abs(Int(self.latitude))) +
                   String(format: "%05.2f'", abs(self.latitude.truncatingRemainder(dividingBy: 1)) * 60)
        var longitudeString = String(format: "%03d° ", abs(Int(self.longitude))) +
                   String(format: "%05.2f'", abs(self.longitude.truncatingRemainder(dividingBy: 1)) * 60)
        
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
