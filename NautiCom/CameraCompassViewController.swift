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
    
    var courseSub: AnyCancellable?
    
    let cameraManager = CameraManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup camera view
        cameraManager.addPreviewLayerToView(cameraView)
        cameraManager.shouldEnableTapToFocus = false

        // Updated course in courseView
        courseSub = compass.$course.sink { (course) in
            self.courseView.setCourse(to: Int(course))
            if let courseDeviation = self.compass.courseDeviation {
                self.courseView.showFixedCourse(with: Int(courseDeviation))
            } else {
                self.courseView.hideFixedCourse()
            }
        }
    }
    
    
    // Fix/Release course when tapping on view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if compass.isFixedCourseDisplayed {
            compass.releaseCourse()
        } else {
            compass.fixCourse()
        }
    }
    
    
    
    @IBAction func unwindToDashboard(_ unwindSegue: UIStoryboardSegue) {
//        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
}
