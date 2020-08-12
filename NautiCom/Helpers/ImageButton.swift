//
//  ImageButton.swift
//  NautiCom
//
//  Created by Pascal Braband on 07.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit

class ImageButton: UIButton {
    
    @IBInspectable var primaryColor: UIColor?
    @IBInspectable var highlightColor: UIColor?

    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightColor : primaryColor
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    func setup() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.layer.masksToBounds = false
    }
}
