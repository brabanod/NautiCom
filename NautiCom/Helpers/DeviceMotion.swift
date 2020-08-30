//
//  DeviceMotion.swift
//  NautiCom
//
//  Created by Pascal Braband on 14.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit
import CoreMotion
import Combine

class DeviceMotion: NSObject {

    let motionManager = CMMotionManager()
    
    // For an explanation on yaw, roll, pitch, see here:
    // https://de.wikipedia.org/wiki/Roll-Nick-Gier-Winkel
    
    /** Device yaw in radians. */
    @Published var yaw: CGFloat = 0.0
    
    /** Device roll in radians. */
    @Published var roll: CGFloat = 0.0
    
    /** Device pitch in radians */
    @Published var pitch: CGFloat = 0.0
    
    override init() {
        super.init()
        
        // Setup gyroscope and calculate device yaw
        motionManager.deviceMotionUpdateInterval = 1.0/45
        if let operationQueue = OperationQueue.current {
            motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: operationQueue) { (deviceData, error) in
                if let gravity = deviceData?.gravity {
                    let length = sqrt(gravity.x * gravity.x + gravity.y * gravity.y + gravity.z * gravity.z)
                    
                    // Imagine the unit circle. normalizedPoint is a point in this circle, indicating the adjacent side (x) and the opposite side (y) in the triangle.
                    let normalizedPoint = CGPoint(x: -gravity.x / length, y: gravity.y / length)
                    
                    // This way the angle can be calculated
                    var angle = atan(normalizedPoint.y/normalizedPoint.x)
                    
                    // Angle still needs to be transformed, so that 0 is at pi/2 and -pi/2
                    // So the unit circle needs to be shifted by pi/2
                    if angle >= 0 {
                        angle -= CGFloat.pi/2
                    } else {
                        angle += CGFloat.pi/2
                    }
                    self.yaw = angle
                    
                    // Calculate device roll
                    self.roll = -normalizedPoint.x
                    self.pitch = -normalizedPoint.y
                }
                // If no gyroscope data is available, then hide the level indicator
                else {
                    self.yaw = 0.0
                    self.roll = 0.0
                    self.pitch = 0.0
                }
            }
        }
    }
}
