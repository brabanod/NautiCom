//
//  LocationPermissionCollector.swift
//  NautiCom
//
//  Created by Pascal Braband on 04.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit
import CoreLocation

class LocationPermissionCollector: NSObject, CLLocationManagerDelegate {
    
    public var status: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    private var completion: (() -> ())?
    private var locationManager = CLLocationManager()
    
    
    func request(completion: @escaping () -> ()) {
        self.completion = completion
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            // Redirect to settings if status denied
            showSettingsRedirectAlert()
        }
        else if status == .notDetermined {
            // Request if status not determined
            locationManager.requestWhenInUseAuthorization()
        } else {
            completion()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self.completion?()
        }
    }
    
    private func showSettingsRedirectAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Location Services Permission", comment: "Title for location services settings alert."), message: NSLocalizedString("Location Services Permission Message", comment: "Message for location services settings alert."), preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: "Name of Settings app."), style: .default) { (action) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel button title."), style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if rootViewController?.presentedViewController != nil {
            rootViewController = rootViewController?.presentedViewController
        }
        rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    deinit {
        locationManager.delegate = nil
    }
}
