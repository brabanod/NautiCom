//
//  DashboardViewController.swift
//  NautiCom
//
//  Created by Pascal Braband on 04.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        if AppStart.isFirstAppStart() {
            performSegue(withIdentifier: "OnboardingShowSegue", sender: self)
        }
    }

}

