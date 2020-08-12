//
//  DashboardViewController.swift
//  NautiCom
//
//  Created by Pascal Braband on 04.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit
import CoreLocation
import Combine

class DashboardViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var compass: CompassView!
    
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var deviationLabel: UILabel!
    @IBOutlet weak var lattitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var sogLabel: UILabel!
    @IBOutlet weak var cogLabel: UILabel!
    
    var locationManager: CLLocationManager!
    
    // MARK: Subscriptions
    var courseSub: AnyCancellable?
    var deviationSub: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get location updates
        locationManager = CLLocationManager()
        
        // Set default values for coordinates label
        lattitudeLabel.text = "—"
        longitudeLabel.text = "—"
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        courseSub = compass.$course.sink { (course) in
            let courseText = self.courseString(from: Int(course))
            self.courseLabel.text = courseText
            self.cogLabel.text = courseText
            
            // Set course Deviation label
            if let courseDeviation = self.compass.courseDeviation {
                if courseDeviation < 0 {
                    self.deviationLabel.text = "-\(abs(Int(courseDeviation)))°"
                } else {
                    self.deviationLabel.text = "+\(abs(Int(courseDeviation)))°"
                }
                self.deviationLabel.textColor = self.compass.fixedCourseColor
            } else {
                self.deviationLabel.text = "±0°"
                self.deviationLabel.textColor = .white
            }
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        if AppStart.isFirstAppStart() {
            performSegue(withIdentifier: "OnboardingShowSegue", sender: self)
        }
    }
    
    
    func courseString(from course: Int) -> String {
        return String(format: "%03d°", course)
    }
}




extension DashboardViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let coordinateString = location.coordinate.string()
            lattitudeLabel.text = coordinateString.0
            longitudeLabel.text = coordinateString.1
            sogLabel.text = "\(String(format: "%.1f", location.speed.toKnots())) kn"
        }
    }
}

