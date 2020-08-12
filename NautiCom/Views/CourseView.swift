//
//  CourseView.swift
//  NautiCom
//
//  Created by Pascal Braband on 12.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit

class CourseView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    func setup() {
        print(self.constraints)
        print(self.frame)
    }

}
