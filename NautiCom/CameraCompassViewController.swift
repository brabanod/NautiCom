//
//  CameraCompassViewController.swift
//  NautiCom
//
//  Created by Pascal Braband on 12.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit
import Combine

class CameraCompassViewController: UIViewController {

    @IBOutlet weak var compass: CompassView!
    @IBOutlet weak var courseView: CourseView!
    
    var courseSub: AnyCancellable?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
