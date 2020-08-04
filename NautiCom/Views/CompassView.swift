//
//  CompassView.swift
//  NautiCom
//
//  Created by Pascal Braband on 04.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit
import CoreLocation

@IBDesignable
class CompassView: UIView {
    
    // MARK: - Transform Constants
    let zDistance: CGFloat = 180
    let textBoxPadding: CGFloat = 15
    let cardinalPadding: CGFloat = 5
    let textBoxSize = CGSize(width: 150.0, height: 40.0)
    let dotSize = CGSize(width: 6.0, height: 6.0)
    let smallTikSize = CGSize(width: 3.0, height: 16.0)
    let largeTikSize = CGSize(width: 3.0, height: 20.0)
    let pinMarkerSize = CGSize(width: 3.0, height: 55.0)
    
    
    
    
    // MARK: - Display Constants
    let cardinalFontSize: CGFloat = 30.0
    let cardinalFont = CTFontCreateUIFontForLanguage(.emphasizedSystem, 16.0, nil)//CTFontCreateWithName(UIFont.systemFont(ofSize: 16.0, weight: .black).fontName as CFString, 16.0, nil)
    let degreeFontSize: CGFloat = 24.0
    let degreeFont = CTFontCreateWithName("SFUI-Thin" as CFString, 16.0,  nil)
    let primaryColor: UIColor = .white
    
    let centerMarkerColor = UIColor(red: 1.0, green: 0.8, blue: 0.031, alpha: 1.0)
    let starboardMarkerColor = UIColor(red: 0.204, green: 0.780, blue: 0.349, alpha: 1.0)
    let portsideMarkerColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
    
    
    
    // MARK: - Markers
    let cardinals = ["N", "O", "S", "W"]
    let subcardinals = ["NO", "SO", "SW", "NW"]
    let degrees = [0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330]
    
    let cardinalsPosition: [CGFloat] = [0, 90, 180, 270]
    let subcardinalsPosition: [CGFloat] = [45, 135, 225, 315]
    let tiks5degreesPosition: [CGFloat] = [5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125, 135, 145, 155, 165, 175, 185, 195, 205, 215, 225, 235, 245, 255, 265, 275, 285, 295, 305, 315, 325, 335, 345, 355]
    let tiks10degreesPosition: [CGFloat] = [10, 20, 40, 50, 70, 80, 100, 110, 130, 140, 160, 170, 190, 200, 220, 230, 250, 260, 280, 290, 310, 320, 340, 350]
    let tiks30degreesPosition: [CGFloat] = [0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330]
    
    
    
    
    // MARK: - Marker Layers
    
    // Every 90° there are cardinal marks as text (0°, 90°, 180°, 270°)
    var cardinalLayers: [CALayer] = [CALayer]()
    
    // Every 90° there are subcardinal marks as text (45°, 135°, 225°, 315°)
    var subcardinalLayers: [CALayer] = [CALayer]()
    
    // Every 30° there is a degree mark as text (0°, 30°, 60°, 90°, ...)
    var degreeLayers: [CALayer] = [CALayer]()
    
    // Every 5° there is a dot/tik, starting from 5°, 15°, 25°, ...
    var tiks5degrees: [CALayer] = [CALayer]()
    
    // Every 10° there is a tik, except for degrees divisible by 30
    // Starting from 10°, 20°, 40°, 50°, 70°, ...
    var tiks10degrees: [CALayer] = [CALayer]()
    
    // Every 30° there is a tik, starting from 0°, 30°, 60°, 90°, ...
    var tiks30degrees: [CALayer] = [CALayer]()
    
    // Marker for indicating the heading/center
    var centerMarker: CALayer = CALayer()
    
    // Marker for indicating the fixed course
    var fixedCourseMarker: CALayer = CALayer()
    
    // Bar which stretches over from the center to the fixed course indicator
    var fixedCourseBarLeft: CALayer = CALayer()
    var fixedCourseBarRight: CALayer = CALayer()
    
    
    
    
    // MARK: - Compass Properties
    @Published private(set) var course: CGFloat = 0.0 {
        willSet {
            previousCourseDeviation = courseDeviation
        }
    }
    private(set) var fixedCourse: CGFloat? = nil
    
    // Returns the deviation of the current course to the fixed course
    public var courseDeviation: CGFloat? {
        if let fixedCourse = fixedCourse {
            let fixedCounterCourse = normalizeCourse(degrees: fixedCourse + 180)
            if fixedCourse >= 0, fixedCourse < 180 {
                if course > fixedCounterCourse {
                    return -fixedCourse - (360 - course)
                } else {
                    return course - fixedCourse
                }
            } else {
                if course < fixedCounterCourse {
                    return (360 - fixedCourse) + course
                } else {
                    return course - fixedCourse
                }
            }
        } else {
            return nil
        }
    }
    
    // Track the previous course deviation to register if course deviation switched (from -179 to +179)
    var previousCourseDeviation: CGFloat? = nil
    var courseDeviationSwitched: Bool {
        if let previousDeviation = previousCourseDeviation, let currentDeviation = courseDeviation {
            return previousDeviation < 0 && currentDeviation > 0 || previousDeviation > 0 && currentDeviation < 0
        } else {
            return false
        }
    }
    
    private var fixedCourseColor: UIColor {
        if let courseDeviation = self.courseDeviation {
            return (courseDeviation < 0) ? portsideMarkerColor : starboardMarkerColor
        } else {
            return UIColor.clear
        }
    }
    
    private var isFixedCourseDisplayed: Bool {
        return fixedCourseMarker.opacity == 1.0
    }
    
    private var locationManager: CLLocationManager!
    
    
    
    
    
    var pos330Layer: CATextLayer!
    var pos300Layer: CATextLayer!
    var pos270Layer: CATextLayer!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        setupCompass()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
        setupCompass()
    }
    
    
    private func setupCompass() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.activityType = .otherNavigation
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            self.locationManager.stopUpdatingHeading()
            self.locationManager.startUpdatingHeading()
        }
    }
    
    
    private func setupLayers() {
        // Mask gradient
        let maskGradient = CAGradientLayer()
        maskGradient.colors = [UIColor.white.withAlphaComponent(0.0).cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.white.withAlphaComponent(0.0).cgColor]
        maskGradient.locations = [0.0, 0.3, 0.7, 1.0]
        maskGradient.startPoint = CGPoint(x: 0.0, y: 0.5);
        maskGradient.endPoint = CGPoint(x: 1.0, y: 0.5);
        self.layer.mask = maskGradient
        
        // Setup Fixed Course Marker
        // FIXME: Shadow
        fixedCourseMarker.anchorPointZ = self.zDistance
        self.layer.addSublayer(fixedCourseMarker)
        
        // Setup Fixed Course Bar
        fixedCourseBarLeft.backgroundColor = portsideMarkerColor.cgColor
        fixedCourseBarRight.backgroundColor = starboardMarkerColor.cgColor
        self.layer.addSublayer(fixedCourseBarLeft)
        self.layer.addSublayer(fixedCourseBarRight)
        
        // Setup Center Marker
        // FIXME: Shadow not working
        centerMarker.backgroundColor = centerMarkerColor.cgColor
        centerMarker.shadowColor = UIColor.red.cgColor
        centerMarker.shadowOffset = CGSize(width: 10.0, height: 50.0)
        centerMarker.shadowRadius = 20
        centerMarker.shadowOpacity = 1.0
        centerMarker.masksToBounds = false
        self.layer.addSublayer(centerMarker)
        
        // Setup Cardinal Text Layers
        for (deg, text) in zip(cardinalsPosition, cardinals) {
            let textLayer = CATextLayer()
            textLayer.font = cardinalFont
            textLayer.fontSize = cardinalFontSize
            textLayer.string = text
            textLayer.foregroundColor = primaryColor.cgColor
            textLayer.alignmentMode = CATextLayerAlignmentMode.center
            textLayer.contentsScale = UIScreen.main.scale
            
            textLayer.anchorPointZ = zDistance
            textLayer.transform = transformForRotation(degrees: deg - course)
            self.layer.addSublayer(textLayer)
            cardinalLayers.append(textLayer)
        }
        
        // Setup Degree Text Layers
        for deg in tiks30degreesPosition {
            let textLayer = CATextLayer()
            textLayer.font = degreeFont
            textLayer.fontSize = degreeFontSize
            textLayer.string = "\(Int(deg))"
            textLayer.foregroundColor = primaryColor.cgColor
            textLayer.alignmentMode = CATextLayerAlignmentMode.center
            textLayer.contentsScale = UIScreen.main.scale
            
            textLayer.anchorPointZ = zDistance
            textLayer.transform = transformForRotation(degrees: deg - course)
            self.layer.addSublayer(textLayer)
            degreeLayers.append(textLayer)
        }
        
        // Setup Tiks
        let setupTikLayer: (CGFloat) -> CALayer = { (_ deg: CGFloat) in
            let degreeTik = CALayer()
            degreeTik.backgroundColor = self.primaryColor.cgColor
            
            degreeTik.anchorPointZ = self.zDistance
            degreeTik.transform = self.transformForRotation(degrees: deg - self.course)
            self.layer.addSublayer(degreeTik)
            return degreeTik
        }
        
        for deg in tiks5degreesPosition {
            let degreeTik = setupTikLayer(deg)
            tiks5degrees.append(degreeTik)
        }
        
        for deg in tiks10degreesPosition {
            let degreeTik = setupTikLayer(deg)
            tiks10degrees.append(degreeTik)
        }
        
        for deg in tiks30degreesPosition {
            let degreeTik = setupTikLayer(deg)
            tiks30degrees.append(degreeTik)
        }
    }
    
    
    
    override func draw(_ rect: CGRect) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.09)
        self.layer.mask?.frame = rect
        
        // Draw Fixed Course Indicators
        if let courseDeviation = courseDeviation {
            let fixedCourseMarkerFrame = CGRect(x: (rect.width - pinMarkerSize.width)/2, y: (rect.height - pinMarkerSize.height)/2, width: pinMarkerSize.width, height: pinMarkerSize.height)
            
            // Angle for bar should be limited by the visible side of compass
            let clampedFixedCourse = clamp(courseDeviation, minValue: -90, maxValue: 90)
            
            let fixedCourseBarLeftWidth = min(cos((90 - clampedFixedCourse) * CGFloat.pi / 180), 0)
            let fixedCourseBarLeftFrame = CGRect(x: rect.width/2, y: (rect.height - smallTikSize.height)/2 - (largeTikSize.height - smallTikSize.height), width: fixedCourseBarLeftWidth * zDistance, height: largeTikSize.height)
            let fixedCourseBarRightWidth = max(cos((90 - clampedFixedCourse) * CGFloat.pi / 180), 0)
            let fixedCourseBarRightFrame = CGRect(x: rect.width/2, y: (rect.height - smallTikSize.height)/2 - (largeTikSize.height - smallTikSize.height), width: fixedCourseBarRightWidth * zDistance, height: largeTikSize.height)
            
            // Initial drawing (to prevent marker from animating in from a different position than center)
            if !isFixedCourseDisplayed {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                fixedCourseMarker.frame = fixedCourseMarkerFrame
                fixedCourseMarker.transform = transformForRotation(degrees: 0)
                fixedCourseBarLeft.frame = fixedCourseBarLeftFrame
                fixedCourseBarRight.frame = fixedCourseBarRightFrame
                CATransaction.commit()
            }
            
            // If course deviation switched, set marker position without animation to prevent marker being animated from one side of compass to the other
            if courseDeviationSwitched {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                fixedCourseMarker.transform = transformForRotation(degrees: -clampedFixedCourse)
                CATransaction.commit()
            }
            
            // Draw Fixed Course marker
            fixedCourseMarker.opacity = 1.0
            fixedCourseMarker.frame = fixedCourseMarkerFrame
            fixedCourseMarker.cornerRadius = pinMarkerSize.width / 2
            fixedCourseMarker.backgroundColor = fixedCourseColor.cgColor
            fixedCourseMarker.transform = transformForRotation(degrees: -clampedFixedCourse)
            
            // Draw Fixed Course Bar
            fixedCourseBarLeft.opacity = 0.45
            fixedCourseBarLeft.frame = fixedCourseBarLeftFrame
            fixedCourseBarRight.opacity = 0.45
            fixedCourseBarRight.frame = fixedCourseBarRightFrame
        } else {
            fixedCourseMarker.opacity = 0.0
            fixedCourseBarLeft.opacity = 0.0
            fixedCourseBarRight.opacity = 0.0
        }
        
        // Draw Center Marker
        centerMarker.frame = CGRect(x: (rect.width - pinMarkerSize.width)/2, y: (rect.height - pinMarkerSize.height)/2, width: pinMarkerSize.width, height: pinMarkerSize.height)
        centerMarker.cornerRadius = pinMarkerSize.width / 2
        
        
        // Draw Cardinal Text
        let cardinalTextFrame = CGRect(x: (rect.width - textBoxSize.width)/2, y: (rect.height + smallTikSize.height)/2 + cardinalPadding, width: textBoxSize.width, height: textBoxSize.height)
        drawText(positions: cardinalsPosition, layers: cardinalLayers, frame: cardinalTextFrame)
        
        // Draw Degree Text
        let degreeTextFrame = CGRect(x: (rect.width - textBoxSize.width)/2, y: (rect.height - textBoxSize.height - smallTikSize.height)/2 - textBoxPadding, width: textBoxSize.width, height: textBoxSize.height)
        drawText(positions: tiks30degreesPosition, layers: degreeLayers, frame: degreeTextFrame)
        
        // Draw 5° Tiks
        let tik5degreeFrame = CGRect(x: (rect.width - dotSize.width)/2, y: (rect.height - dotSize.height)/2, width: dotSize.width, height: dotSize.height)
        drawTik(positions: tiks5degreesPosition, layers: tiks5degrees, frame: tik5degreeFrame)
        
        // Draw 10° Tiks
        let tik10degreeFrame = CGRect(x: (rect.width - smallTikSize.width)/2, y: (rect.height - smallTikSize.height)/2, width: smallTikSize.width, height: smallTikSize.height)
        drawTik(positions: tiks10degreesPosition, layers: tiks10degrees, frame: tik10degreeFrame)
        
        // Draw 30° Tiks
        let tik30degreeFrame = CGRect(x: (rect.width - largeTikSize.width)/2, y: (rect.height - smallTikSize.height)/2 - (largeTikSize.height - smallTikSize.height), width: largeTikSize.width, height: largeTikSize.height)
        drawTik(positions: tiks30degreesPosition, layers: tiks30degrees, frame: tik30degreeFrame)
        
        CATransaction.commit()
    }
    
    
    private func drawText(positions: [CGFloat], layers: [CALayer], frame: CGRect) {
        for (deg, textLayer) in zip(positions, layers) {
            textLayer.frame = frame
            
            let positionDeg = normalizeCourse(degrees: deg - course)
            textLayer.transform = transformForRotation(degrees: positionDeg)
            
            // Only display if degree is on visible side (270° to 90°)
            if positionDeg >= 80, positionDeg <= 280 {
                textLayer.opacity = 0.0
            } else {
                textLayer.opacity = 1.0
            }
        }
    }
    
    
    private func drawTik(positions: [CGFloat], layers: [CALayer], frame: CGRect) {
        for (deg, tikLayer) in zip(positions, layers) {
            tikLayer.frame = frame
            tikLayer.cornerRadius = frame.width / 2
            
            let positionDeg = self.normalizeCourse(degrees: deg - self.course)
            tikLayer.transform = self.transformForRotation(degrees: positionDeg)
            
            // Only display if degree is on visible side
            if positionDeg >= 80, positionDeg <= 280 {
                tikLayer.opacity = 0.0
            } else {
                tikLayer.opacity = 1.0
            }
        }
    }
    
    
    private func transformForRotation(degrees: CGFloat) -> CATransform3D {
        let rotateTransform = CATransform3DRotate(CATransform3DIdentity, CGFloat(Double(degrees) * Double.pi / 180), 0, 1, 0)
//        rotateTransform.m34 = 1.0 / 1000.0
        return rotateTransform
    }

    
    public func setCourse(degrees: CGFloat) {
        // Normalize course
        course = normalizeCourse(degrees: degrees)
        self.setNeedsDisplay()
    }
    
    
    private func normalizeCourse(degrees: CGFloat) -> CGFloat {
        return (360 + degrees).truncatingRemainder(dividingBy: 360)
    }
    

    public func fixCourse() {
        fixedCourse = course
        self.setNeedsDisplay()
    }
    
    
    public func releaseCourse() {
        fixedCourse = nil
        self.setNeedsDisplay()
    }
}






extension CompassView: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        setCourse(degrees: CGFloat(newHeading.magneticHeading))
    }
}



public func clamp<T>(_ value: T, minValue: T, maxValue: T) -> T where T : Comparable {
    return min(max(value, minValue), maxValue)
}
