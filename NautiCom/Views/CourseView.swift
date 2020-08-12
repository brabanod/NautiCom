//
//  CourseView.swift
//  NautiCom
//
//  Created by Pascal Braband on 12.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit

class CourseView: UIView {
    
    // MARK: Subviews
    private var container: UIView!
    private var courseContainer: UIView!
    private var fixedCourseContainer: UIView!
    
    private var separator: UIView!
    
    private var courseLabel: UILabel!
    private var fixedCourseLabel: UILabel!
    
    
    // MARK: Constraints
    private var containerHeightFull: NSLayoutConstraint!
    private var containerHeightHalf: NSLayoutConstraint!
    private var courseContainerHeightFull: NSLayoutConstraint!
    private var courseContainerHeightHalf: NSLayoutConstraint!
    
    
    // MARK: State
    var isFixedCourseDisplayed: Bool!
    
    
    // MARK: Misc
    let starboardColor = UIColor(red: 0.204, green: 0.780, blue: 0.349, alpha: 1.0)
    let portsideColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    private func setup() {
        self.backgroundColor = .clear
        self.layer.masksToBounds = false
        
        // Setup container
        container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.clipsToBounds = true
        
        container.layer.cornerRadius = self.frame.height / 4
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.5
        container.layer.shadowRadius = 5.0
        container.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        container.layer.masksToBounds = false
        
        container.backgroundColor = UIColor(red: 28.0/255.0, green: 28.0/255.0, blue: 28.0/255.0, alpha: 1.0)
        self.addSubview(container)
        containerHeightFull = NSLayoutConstraint(item: container!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0)
        containerHeightHalf = NSLayoutConstraint(item: container!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0.0)
        let containerWidth = NSLayoutConstraint(item: container!, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0)
        self.addConstraints([containerHeightFull!, containerHeightHalf, containerWidth])
        
        // Setup course container
        courseContainer = UIView()
        courseContainer.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(courseContainer)
        courseContainerHeightFull = NSLayoutConstraint(item: courseContainer!, attribute: .height, relatedBy: .equal, toItem: container, attribute: .height, multiplier: 1.0, constant: 0.0)
        courseContainerHeightHalf = NSLayoutConstraint(item: courseContainer!, attribute: .height, relatedBy: .equal, toItem: container, attribute: .height, multiplier: 0.5, constant: 0.0)
        container.addConstraints([courseContainerHeightFull, courseContainerHeightHalf,
            NSLayoutConstraint(item: courseContainer!, attribute: .width, relatedBy: .equal, toItem: container, attribute: .width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: courseContainer!, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0.0)])
        
        // Setup fixed course container
        fixedCourseContainer = UIView()
        fixedCourseContainer.translatesAutoresizingMaskIntoConstraints = false
        fixedCourseContainer.clipsToBounds = true
        container.addSubview(fixedCourseContainer)
        container.addConstraints([
            NSLayoutConstraint(item: fixedCourseContainer!, attribute: .height, relatedBy: .equal, toItem: container, attribute: .height, multiplier: 0.5, constant: 0.0),
            NSLayoutConstraint(item: fixedCourseContainer!, attribute: .width, relatedBy: .equal, toItem: container, attribute: .width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: fixedCourseContainer!, attribute: .top, relatedBy: .equal, toItem: courseContainer, attribute: .bottom, multiplier: 1.0, constant: 0.0)])
        
        // Setup separator
        separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.white
        separator.layer.opacity = 0.6
        fixedCourseContainer.addSubview(separator)
        fixedCourseContainer.addConstraints([
            NSLayoutConstraint(item: separator!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0),
            NSLayoutConstraint(item: separator!, attribute: .width, relatedBy: .equal, toItem: fixedCourseContainer, attribute: .width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: separator!, attribute: .top, relatedBy: .equal, toItem: fixedCourseContainer, attribute: .top, multiplier: 1.0, constant: 0.0)])
        
        // Setup course label
        courseLabel = UILabel()
        courseLabel.translatesAutoresizingMaskIntoConstraints = false
        courseLabel.font = UIFont.systemFont(ofSize: 24.0)
        courseLabel.textColor = .white
        courseContainer.addSubview(courseLabel)
        courseContainer.addConstraints([
            NSLayoutConstraint(item: courseLabel!, attribute: .centerX, relatedBy: .equal, toItem: courseContainer, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: courseLabel!, attribute: .centerY, relatedBy: .equal, toItem: courseContainer, attribute: .centerY, multiplier: 1.0, constant: 0.0)])
        
        // Setup fixed course label
        fixedCourseLabel = UILabel()
        fixedCourseLabel.translatesAutoresizingMaskIntoConstraints = false
        fixedCourseLabel.font = UIFont.systemFont(ofSize: 24.0)
        fixedCourseLabel.textColor = .white
        fixedCourseContainer.addSubview(fixedCourseLabel)
        fixedCourseContainer.addConstraints([
            NSLayoutConstraint(item: fixedCourseLabel!, attribute: .centerX, relatedBy: .equal, toItem: fixedCourseContainer, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: fixedCourseLabel!, attribute: .centerY, relatedBy: .equal, toItem: fixedCourseContainer, attribute: .centerY, multiplier: 1.0, constant: 0.0)])
        
        
        // Initial contstraint setup
        isFixedCourseDisplayed = false
        containerHeightFull.isActive = false
        containerHeightHalf.isActive = true
        courseContainerHeightHalf.isActive = false
        courseContainerHeightFull.isActive = true
        
        separator.layer.opacity = 0.0
        fixedCourseLabel.layer.opacity = 0.0
        
        courseLabel.text = "278°"
        fixedCourseLabel.text = "+15°"
    }
    
    
    public func setCourse(to course: Int) {
        courseLabel.text = "\(course)°"
    }
    
    
    public func showFixedCourse(with fixedCourse: Int) {
        if fixedCourse < 0 {
            fixedCourseLabel.text = "-\(abs(fixedCourse))°"
            fixedCourseLabel.textColor = portsideColor
        } else {
            fixedCourseLabel.text = "+\(abs(fixedCourse))°"
            fixedCourseLabel.textColor = starboardColor
        }
        
        // Only update if currently hidden (not already shown)
        guard !isFixedCourseDisplayed else { return }
        isFixedCourseDisplayed = true
        updateExpansionConstrains()
    }
    
    
    public func hideFixedCourse() {
        fixedCourseLabel.text = ""
        
        // Only update if currently shown (not already hidden)
        guard isFixedCourseDisplayed else { return }
        isFixedCourseDisplayed = false
        updateExpansionConstrains()
    }
    
    
    public func updateExpansionConstrains() {
        if isFixedCourseDisplayed {
            containerHeightHalf.isActive = false
            containerHeightFull.isActive = true
            courseContainerHeightFull.isActive = false
            courseContainerHeightHalf.isActive = true
        } else {
            containerHeightFull.isActive = false
            containerHeightHalf.isActive = true
            courseContainerHeightHalf.isActive = false
            courseContainerHeightFull.isActive = true
        }
        
        
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.64, 1.61, 0.35, 1.00)
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(timingFunction)

        let transformWithScale: (CGFloat) -> (CATransform3D) = { scale in
            return CATransform3DMakeScale(scale, scale, 1.0)
        }
        
        UIView.animate(withDuration: 0.1) {
            self.separator.layer.opacity = self.isFixedCourseDisplayed ? 0.5 : 0.0
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)

        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseIn, animations: {
            self.fixedCourseLabel.layer.opacity = self.isFixedCourseDisplayed ? 1.0 : 0.0
        }, completion: nil)

        CATransaction.commit()
        
        
        CATransaction.begin()
        let scaleUpAnimation = CABasicAnimation(keyPath: "transform")
        scaleUpAnimation.fromValue = transformWithScale(1.0)
        scaleUpAnimation.toValue = transformWithScale(1.1)

        scaleUpAnimation.duration = 0.05
        scaleUpAnimation.timingFunction = CAMediaTimingFunction.init(name: .easeOut)

        let scaleDownAnimation = CABasicAnimation(keyPath: "transform")
        scaleDownAnimation.fromValue = transformWithScale(1.1)
        scaleDownAnimation.toValue = transformWithScale(1.0)
        scaleDownAnimation.duration = 0.3
        scaleDownAnimation.beginTime = 0.05
        scaleDownAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.42, 1.53, 0.31, 0.99)
        
        let scaleAnimation = CAAnimationGroup()
        scaleAnimation.duration = 0.35
        scaleAnimation.animations = [scaleUpAnimation, scaleDownAnimation]
        container.layer.add(scaleAnimation, forKey: "scale")
        CATransaction.commit()
    }
}
