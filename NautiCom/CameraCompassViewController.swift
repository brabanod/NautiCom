//
//  CameraCompassViewController.swift
//  NautiCom
//
//  Created by Pascal Braband on 12.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit
import Combine
import CameraManager

class CameraCompassViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var compass: CompassView!
    @IBOutlet weak var courseView: CourseView!
    @IBOutlet weak var cameraAccessView: UIView!
    
    let permissions = PermissionCollector()
    
    var courseSub: AnyCancellable?
    
    let cameraManager = CameraManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitioningDelegate = self
        
        // Setup camera view
        cameraManager.shouldRespondToOrientationChanges = false
        cameraManager.addPreviewLayerToView(cameraView)

        // Updated course in courseView
        courseSub = compass.$course.sink { (course) in
            self.courseView.setCourse(to: Int(course))
            if let courseDeviation = self.compass.courseDeviation {
                self.courseView.showFixedCourse(with: Int(courseDeviation))
            } else {
                self.courseView.hideFixedCourse()
            }
        }
        
        // Add gestures to fix/release compass coruse
        let fixGestureTap = UITapGestureRecognizer(target: self, action: #selector(tapFixCourse))
        courseView.addGestureRecognizer(fixGestureTap)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // Check if camera access is enabled
        if permissions.cameraPermission.status != .authorized {
            cameraAccessView.isHidden = false
        } else {
            cameraAccessView.isHidden = true
        }
    }
    
    
    @IBAction func presentDashboard(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Fix/Release course when tapping on view
    @objc func tapFixCourse() {
        if compass.isFixedCourseDisplayed {
            compass.releaseCourse()
        } else {
            compass.fixCourse()
        }
    }
    
    
    @IBAction func allowCameraAccessButtonPressed(_ sender: Any) {
        permissions.requestCameraPermission {
            self.cameraAccessView.isHidden = true
        }
    }
    
    
    @IBAction func unwindToDashboard(_ unwindSegue: UIStoryboardSegue) {
//        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
}
