//
//  CameraPermissionCollector.swift
//  NautiCom
//
//  Created by Pascal Braband on 04.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPermissionCollector: NSObject {
    
    var status: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    func request(completion: @escaping () -> ()) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        if status == .denied {
            // Redirect to settings if status denied
            showSettingsRedirectAlert()
        }
        else if status == .notDetermined {
            // Request if status not determined
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { finished in
                DispatchQueue.main.async {
                    if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                        completion()
                    }
                }
            })
        } else {
            completion()
        }
    }
    
    
    private func showSettingsRedirectAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Camera Permission", comment: "Title for camera settings alert."), message: NSLocalizedString("Camera Permission Message", comment: "Message for camera settings alert."), preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: "Name of Settings app."), style: .default) { (action) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action."), style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if rootViewController?.presentedViewController != nil {
            rootViewController = rootViewController?.presentedViewController
        }
        rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    
    
}

