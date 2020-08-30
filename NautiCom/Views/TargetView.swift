//
//  TargetView.swift
//  NautiCom
//
//  Created by Pascal Braband on 12.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit
import Combine

@IBDesignable
class TargetView: UIView {
    
    /** Value between -1.0 and 1.0, indicating how much the target circle should be shifted on the y-axis from the center. */
    @IBInspectable public var centerOffset: CGFloat = 0.0
    
    /** Width of all lines for the `TargetView`. */
    @IBInspectable public var targetLineWidth: CGFloat = 1.0
    
    /** Distance which the lines have from the center dot. */
    @IBInspectable public var centerPadding: CGFloat = 10.0
    
    /** The length of the level indicator lines. */
    @IBInspectable public var levelIndicatorLength: CGFloat = 60.0
    
    /** The padding between the level indicator lines and the target outer circle. */
    @IBInspectable public var levelIndicatorPadding: CGFloat = 10.0
    
    
    // MARK: Layers
    private let innerDot = CAShapeLayer()
    private let innerTargetCircle = CAShapeLayer()
    private let outerTargetCircle = CAShapeLayer()
    private let verticalLineUpper = CAShapeLayer()
    private let verticalLineLower = CAShapeLayer()
    private let horizontalLineLeft = CAShapeLayer()
    private let horizontalLineRight = CAShapeLayer()
    private let levelIndicatorLeft = CAShapeLayer()
    private let levelIndicatorRight = CAShapeLayer()
    private let levelLayer = CALayer()
    
    
    let deviceMotion = DeviceMotion()
    var rotationSub: AnyCancellable?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    func setup() {
        self.isUserInteractionEnabled = false
        
        // Setup updating level indicator
        rotationSub = deviceMotion.$yaw.sink { (rotation) in
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.levelLayer.transform = CATransform3DMakeRotation(rotation, 0.0, 0.0, 1.0)
            CATransaction.commit()
        }
        
        // Setup layers
        
        // Circles
        self.layer.addSublayer(innerDot)
        
        innerTargetCircle.strokeColor = UIColor.white.cgColor
        innerTargetCircle.fillColor = UIColor.clear.cgColor
        innerTargetCircle.lineWidth = targetLineWidth
        self.layer.addSublayer(innerTargetCircle)
        
        outerTargetCircle.strokeColor = UIColor.white.cgColor
        outerTargetCircle.fillColor = UIColor.clear.cgColor
        outerTargetCircle.lineWidth = targetLineWidth
        self.layer.addSublayer(outerTargetCircle)
        
        // Lines
        verticalLineUpper.strokeColor = UIColor.white.cgColor
        verticalLineUpper.lineWidth = targetLineWidth
        self.layer.addSublayer(verticalLineUpper)
        
        verticalLineLower.strokeColor = UIColor.white.cgColor
        verticalLineLower.lineWidth = targetLineWidth
        self.layer.addSublayer(verticalLineLower)
        
        horizontalLineLeft.strokeColor = UIColor.white.cgColor
        horizontalLineLeft.lineWidth = targetLineWidth
        self.layer.addSublayer(horizontalLineLeft)
        
        horizontalLineRight.strokeColor = UIColor.white.cgColor
        horizontalLineRight.lineWidth = targetLineWidth
        self.layer.addSublayer(horizontalLineRight)
        
        // Level indicator
        self.layer.addSublayer(levelLayer)
        
        levelIndicatorLeft.strokeColor = UIColor.white.cgColor
        levelIndicatorLeft.lineWidth = targetLineWidth
        levelLayer.addSublayer(levelIndicatorLeft)
        
        levelIndicatorRight.strokeColor = UIColor.white.cgColor
        levelIndicatorRight.lineWidth = targetLineWidth
        levelLayer.addSublayer(levelIndicatorRight)
        
        // Shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.layer.masksToBounds = false
    }
    

    override func draw(_ rect: CGRect) {
        let targetCenter = CGPoint(x: rect.width/2, y: rect.height/2 - rect.height/2*centerOffset)
        
        // Circles
        innerDot.fillColor = UIColor.white.cgColor
        let dotSize: CGFloat = 2.0
        let dotFrame = CGRect(x: targetCenter.x - dotSize/2, y: targetCenter.y - dotSize/2, width: dotSize, height: dotSize)
        innerDot.path = UIBezierPath(ovalIn: dotFrame).cgPath
        
        let innerTargetCircleSize: CGFloat = 40.0
        let innerTargetCircleFrame = CGRect(x: targetCenter.x - innerTargetCircleSize/2, y: targetCenter.y - innerTargetCircleSize/2, width: innerTargetCircleSize, height: innerTargetCircleSize)
        innerTargetCircle.path = UIBezierPath(ovalIn: innerTargetCircleFrame).cgPath
        
        let outerTargetCircleSize: CGFloat = 180.0
        let outerTargetCircleFrame = CGRect(x: targetCenter.x - outerTargetCircleSize/2, y: targetCenter.y - outerTargetCircleSize/2, width: outerTargetCircleSize, height: outerTargetCircleSize)
        outerTargetCircle.path = UIBezierPath(ovalIn: outerTargetCircleFrame).cgPath
        
        
        // Lines
        let verticalLineUpperPath = UIBezierPath()
        verticalLineUpperPath.move(to: CGPoint(x: rect.width/2, y: 0 + 20)) // 20px gap for status bar
        verticalLineUpperPath.addLine(to: CGPoint(x: rect.width/2, y: targetCenter.y - centerPadding))
        verticalLineUpper.path = verticalLineUpperPath.cgPath
        
        let verticalLineLowerPath = UIBezierPath()
        verticalLineLowerPath.move(to: CGPoint(x: rect.width/2, y: rect.height))
        verticalLineLowerPath.addLine(to: CGPoint(x: rect.width/2, y: targetCenter.y + centerPadding))
        verticalLineLower.path = verticalLineLowerPath.cgPath
        
        let horizontalLineLeftPath = UIBezierPath()
        horizontalLineLeftPath.move(to: CGPoint(x: 0, y: targetCenter.y))
        horizontalLineLeftPath.addLine(to: CGPoint(x: targetCenter.x - centerPadding, y: targetCenter.y))
        horizontalLineLeft.path = horizontalLineLeftPath.cgPath
        
        let horizontalLineRightPath = UIBezierPath()
        horizontalLineRightPath.move(to: CGPoint(x: rect.width, y: targetCenter.y))
        horizontalLineRightPath.addLine(to: CGPoint(x: targetCenter.x + centerPadding, y: targetCenter.y))
        horizontalLineRight.path = horizontalLineRightPath.cgPath
        
        
        // Level indicator
        let levelIndicatorSize: CGFloat = outerTargetCircleSize + 2*(levelIndicatorLength + levelIndicatorPadding)
        levelLayer.transform = CATransform3DIdentity
        levelLayer.frame = CGRect(x: targetCenter.x - levelIndicatorSize/2, y: targetCenter.y - levelIndicatorSize/2, width: levelIndicatorSize, height: levelIndicatorSize)
        
        let levelIndicatorLeftPath = UIBezierPath()
        levelIndicatorLeftPath.move(to: CGPoint(x: 0, y: levelLayer.frame.height/2))
        levelIndicatorLeftPath.addLine(to: CGPoint(x: levelIndicatorLength, y: levelLayer.frame.height/2))
        levelIndicatorLeft.path = levelIndicatorLeftPath.cgPath
        
        let levelIndicatorRightPath = UIBezierPath()
        levelIndicatorRightPath.move(to: CGPoint(x: levelLayer.frame.width, y: levelLayer.frame.height/2))
        levelIndicatorRightPath.addLine(to: CGPoint(x: levelLayer.frame.width - levelIndicatorLength, y: levelLayer.frame.height/2))
        levelIndicatorRight.path = levelIndicatorRightPath.cgPath
    }

}
