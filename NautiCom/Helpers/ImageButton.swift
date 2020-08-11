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
}
