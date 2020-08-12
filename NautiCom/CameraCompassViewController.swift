//
//  CameraCompassViewController.swift
//  NautiCom
//
//  Created by Pascal Braband on 12.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit

class CameraCompassViewController: UIViewController {

    @IBOutlet weak var compass: CompassView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
