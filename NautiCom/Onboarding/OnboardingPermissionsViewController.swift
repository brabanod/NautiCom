//
//  OnboardingPermissionsViewController.swift
//  NautiCom
//
//  Created by Pascal Braband on 04.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit

class OnboardingPermissionsViewController: UIViewController {

    @IBOutlet weak var cameraSymbol: UIImageView!
    @IBOutlet weak var locationSymbol: UIImageView!
    @IBOutlet weak var cameraAccessButton: UIButton!
    @IBOutlet weak var locationServicesButton: UIButton!
    
    let permissions = PermissionCollector()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if permissions.cameraPermission.status == .authorized {
            self.showCameraGranted() 
        }
        if permissions.locationPermission.status == .authorizedWhenInUse {
            self.showLocationGranted()
        }
    }
    
    
    @IBAction func allowCameraAccess(_ sender: Any) {
        permissions.requestCameraPermission {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                self.showCameraGranted()
            }, completion: nil)
        }
    }
    
    
    @IBAction func allowLocationServices(_ sender: Any) {
        permissions.requestLocationPermission {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                self.showLocationGranted()
            }, completion: nil)
        }
    }
    
    
    @IBAction func finishOnboarding(_ sender: Any) {
        // TODO: Check if all permissions were granted -> otherwise alert
        if let pageVC = self.parent as? OnboardingViewController {
            pageVC.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    // MARK: Permission UI
    
    func showCameraGranted() {
        self.cameraSymbol.tintColor = UIColor.systemGreen
        self.cameraAccessButton.isEnabled = false
        self.cameraAccessButton.backgroundColor = UIColor.systemGray2
    }
    
    
    func showCameraNotGranted() {
        self.cameraSymbol.tintColor = UIColor.systemGray2
        self.cameraAccessButton.isEnabled = true
        self.cameraAccessButton.backgroundColor = UIColor.systemBlue
    }
    
    
    func showLocationGranted() {
        self.locationSymbol.tintColor = UIColor.systemGreen
        self.locationServicesButton.isEnabled = false
        self.locationServicesButton.backgroundColor = UIColor.systemGray2
    }
    
    
    func showLocationNotGranted() {
        self.locationSymbol.tintColor = UIColor.systemGray2
        self.locationServicesButton.isEnabled = false
        self.locationServicesButton.backgroundColor = UIColor.systemBlue
    }

}
