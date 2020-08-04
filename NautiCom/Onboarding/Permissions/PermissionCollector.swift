//
//  PermissionCollector.swift
//  NautiCom
//
//  Created by Pascal Braband on 04.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit
import CoreLocation

class PermissionCollector: NSObject, CLLocationManagerDelegate {

    lazy var cameraPermission = CameraPermissionCollector()
    lazy var locationPermission = LocationPermissionCollector()
    
    
    public func requestCameraPermission(completion: @escaping () -> ()) {
        self.cameraPermission.request(completion: completion)
    }
    
    
    public func requestLocationPermission(completion: @escaping () -> ()) {
        self.locationPermission.request(completion: completion)
    }
    
}
