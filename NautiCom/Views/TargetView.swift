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
    private var levelLayer = CALayer()
    
    
    var deviceMotion = DeviceMotion()
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
        rotationSub = deviceMotion.$rotation.sink { (rotation) in
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.levelLayer.transform = CATransform3DMakeRotation(rotation, 0.0, 0.0, 1.0)
            CATransaction.commit()
        }
    }
    

    override func draw(_ rect: CGRect) {
        let targetCenter = CGPoint(x: rect.width/2, y: rect.height/2 - rect.height/2*centerOffset)
        
        // Circles
        
        let innerDot = CAShapeLayer()
        innerDot.fillColor = UIColor.white.cgColor
        let dotSize: CGFloat = 2.0
        let dotFrame = CGRect(x: targetCenter.x - dotSize/2, y: targetCenter.y - dotSize/2, width: dotSize, height: dotSize)
        innerDot.path = UIBezierPath(ovalIn: dotFrame).cgPath
        self.layer.addSublayer(innerDot)
        
        let innerTargetCircle = CAShapeLayer()
        innerTargetCircle.strokeColor = UIColor.white.cgColor
        innerTargetCircle.fillColor = UIColor.clear.cgColor
        innerTargetCircle.lineWidth = targetLineWidth
        let innerTargetCircleSize: CGFloat = 40.0
        let innerTargetCircleFrame = CGRect(x: targetCenter.x - innerTargetCircleSize/2, y: targetCenter.y - innerTargetCircleSize/2, width: innerTargetCircleSize, height: innerTargetCircleSize)
        innerTargetCircle.path = UIBezierPath(ovalIn: innerTargetCircleFrame).cgPath
        self.layer.addSublayer(innerTargetCircle)
        
        let outerTargetCircle = CAShapeLayer()
        outerTargetCircle.strokeColor = UIColor.white.cgColor
        outerTargetCircle.fillColor = UIColor.clear.cgColor
        outerTargetCircle.lineWidth = targetLineWidth
        let outerTargetCircleSize: CGFloat = 180.0
        let outerTargetCircleFrame = CGRect(x: targetCenter.x - outerTargetCircleSize/2, y: targetCenter.y - outerTargetCircleSize/2, width: outerTargetCircleSize, height: outerTargetCircleSize)
        outerTargetCircle.path = UIBezierPath(ovalIn: outerTargetCircleFrame).cgPath
        self.layer.addSublayer(outerTargetCircle)
        
        
        // Lines
        
        let verticalLineUpperPath = UIBezierPath()
        verticalLineUpperPath.move(to: CGPoint(x: rect.width/2, y: 0))
        verticalLineUpperPath.addLine(to: CGPoint(x: rect.width/2, y: targetCenter.y - centerPadding))
        let verticalLineUpper = CAShapeLayer()
        verticalLineUpper.strokeColor = UIColor.white.cgColor
        verticalLineUpper.lineWidth = targetLineWidth
        verticalLineUpper.path = verticalLineUpperPath.cgPath
        self.layer.addSublayer(verticalLineUpper)
        
        let verticalLineLowerPath = UIBezierPath()
        verticalLineLowerPath.move(to: CGPoint(x: rect.width/2, y: rect.height))
        verticalLineLowerPath.addLine(to: CGPoint(x: rect.width/2, y: targetCenter.y + centerPadding))
        let verticalLineLower = CAShapeLayer()
        verticalLineLower.strokeColor = UIColor.white.cgColor
        verticalLineLower.lineWidth = targetLineWidth
        verticalLineLower.path = verticalLineLowerPath.cgPath
        self.layer.addSublayer(verticalLineLower)
        
        let horizontalLineLeftPath = UIBezierPath()
        horizontalLineLeftPath.move(to: CGPoint(x: 0, y: targetCenter.y))
        horizontalLineLeftPath.addLine(to: CGPoint(x: targetCenter.x - centerPadding, y: targetCenter.y))
        let horizontalLineLeft = CAShapeLayer()
        horizontalLineLeft.strokeColor = UIColor.white.cgColor
        horizontalLineLeft.lineWidth = targetLineWidth
        horizontalLineLeft.path = horizontalLineLeftPath.cgPath
        self.layer.addSublayer(horizontalLineLeft)
        
        let horizontalLineRightPath = UIBezierPath()
        horizontalLineRightPath.move(to: CGPoint(x: rect.width, y: targetCenter.y))
        horizontalLineRightPath.addLine(to: CGPoint(x: targetCenter.x + centerPadding, y: targetCenter.y))
        let horizontalLineRight = CAShapeLayer()
        horizontalLineRight.strokeColor = UIColor.white.cgColor
        horizontalLineRight.lineWidth = targetLineWidth
        horizontalLineRight.path = horizontalLineRightPath.cgPath
        self.layer.addSublayer(horizontalLineRight)
        
        
        // Level indicator
        let levelIndicatorSize: CGFloat = outerTargetCircleSize + 2*(levelIndicatorLength + levelIndicatorPadding)
        levelLayer.frame = CGRect(x: targetCenter.x - levelIndicatorSize/2, y: targetCenter.y - levelIndicatorSize/2, width: levelIndicatorSize, height: levelIndicatorSize)
        self.layer.addSublayer(levelLayer)
        
        let levelIndicatorLeftPath = UIBezierPath()
        levelIndicatorLeftPath.move(to: CGPoint(x: 0, y: levelLayer.frame.height/2))
        levelIndicatorLeftPath.addLine(to: CGPoint(x: levelIndicatorLength, y: levelLayer.frame.height/2))
        let levelIndicatorLeft = CAShapeLayer()
        levelIndicatorLeft.strokeColor = UIColor.white.cgColor
        levelIndicatorLeft.lineWidth = targetLineWidth
        levelIndicatorLeft.path = levelIndicatorLeftPath.cgPath
        levelLayer.addSublayer(levelIndicatorLeft)
        
        let levelIndicatorRightPath = UIBezierPath()
        levelIndicatorRightPath.move(to: CGPoint(x: levelLayer.frame.width, y: levelLayer.frame.height/2))
        levelIndicatorRightPath.addLine(to: CGPoint(x: levelLayer.frame.width - levelIndicatorLength, y: levelLayer.frame.height/2))
        let levelIndicatorRight = CAShapeLayer()
        levelIndicatorRight.strokeColor = UIColor.white.cgColor
        levelIndicatorRight.lineWidth = targetLineWidth
        levelIndicatorRight.path = levelIndicatorRightPath.cgPath
        levelLayer.addSublayer(levelIndicatorRight)
        
        levelLayer.transform = CATransform3DMakeRotation(CGFloat.pi/4, 0.0, 0.0, 1.0)
        
        
        // Shadow
        self.layer.cornerRadius = self.frame.height / 4
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.layer.masksToBounds = false
    }

}
