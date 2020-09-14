//
//  GameScene.swift
//  ColorSwitch
//
//  Created by David Schlundt-Bodien on 9/14/20.
//  Copyright © 2020 David Schlundt-Bodien. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var colorSwitch: SKSpriteNode!
    
    override func didMove(to skView: SKView) {
        setupPhysics()
        layoutScene()
    }
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
    }
    
    func layoutScene() {
        
        
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        colorSwitch = SKSpriteNode(imageNamed: "ColorCircle")
        colorSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.height/6)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.height)
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2)
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCatagories.switchCatagory
        colorSwitch.physicsBody?.isDynamic = false
        addChild(colorSwitch)
        
        spawnBall()
        
        
    }
    
    func spawnBall() {
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSize(width: 40.0, height: 40.0)
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCatagories.ballCatagory
        ball.physicsBody?.contactTestBitMask = PhysicsCatagories.switchCatagory
        ball.physicsBody?.collisionBitMask = PhysicsCatagories.none
        addChild(ball)
     }
}
