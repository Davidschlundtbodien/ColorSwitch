//
//  settings.swift
//  ColorSwitch
//
//  Created by David Schlundt-Bodien on 9/14/20.
//  Copyright © 2020 David Schlundt-Bodien. All rights reserved.
//

import SpriteKit

//movement for game scene
enum PhysicsCatagories {
    static let none: UInt32 = 0
    static let ballCatagory: UInt32 = 0x1
    static let switchCatagory: UInt32 = 0x1 << 1
    
}

//Sibling order for game scene
enum ZPositions {
    static let label: CGFloat = 0
    static let ball: CGFloat = 1
    static let colorSwitch: CGFloat = 2
}
