//
//  DeviceHeading.swift
//  NautiCom
//
//  Created by Pascal Braband on 17.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit
import CoreLocation
import Combine

class DeviceHeading: NSObject {
    
    /** Direction in which the device is heading in degrees. */
    @Published public var direction: CGFloat = 0.0
    private let locationManager = CLLocationManager()
    
    private let deviceMotion = DeviceMotion()
    
    
    override init() {
        super.init()
        
        // Setup location manager and receiving updates
        locationManager.delegate = self
        locationManager.activityType = .otherNavigation
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            self.locationManager.stopUpdatingHeading()
            self.locationManager.startUpdatingHeading()
        }
    }

}


extension DeviceHeading: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // Correct heading with device rotation
        direction = CGFloat(newHeading.magneticHeading) + (180/CGFloat.pi * deviceMotion.rotation)
    }
}
