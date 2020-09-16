//
//  GameScene.swift
//  ColorSwitch
//
//  Created by David Schlundt-Bodien on 9/14/20.
//  Copyright © 2020 David Schlundt-Bodien. All rights reserved.
//

import SpriteKit

//Ball color array
enum PlayColors {
    static let colors = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
}

// Switch state
enum SwitchState: Int {
    case red, yellow, green, blue
}


class GameScene: SKScene {
    
    var colorSwitch: SKSpriteNode!
    var switchState = SwitchState.red
    var currentColorIndex: Int?
    let scoreLabel = SKLabelNode(text: "0")
    var score = 0
    
    
    override func didMove(to skView: SKView) {
        setupPhysics()
        layoutScene()
    }
    
    //Gravity for ball
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -3.0)
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene() {
        

        //Scene background
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        //Color Circle
        colorSwitch = SKSpriteNode(imageNamed: "ColorCircle")
        colorSwitch.size = CGSize(width: frame.size.width/4, height: frame.size.height/8.5)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.height)
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2)
        colorSwitch.zPosition = ZPositions.colorSwitch
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCatagories.switchCatagory
        colorSwitch.physicsBody?.isDynamic = false
        addChild(colorSwitch)
        
        //Current Score
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
        
        //Deploys ball
        spawnBall()
        
    }
    
    //Current score updating
    func updateScoreLabel() {
        scoreLabel.text = "\(score)"
        self.physicsWorld.gravity.dy -= 0.1
        print(physicsWorld.gravity.dy)
    }
    
    //Ball object
    func spawnBall() {
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currentColorIndex!], size: CGSize(width: 30.0, height: 30.0))
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.zPosition = ZPositions.ball
        ball.physicsBody?.categoryBitMask = PhysicsCatagories.ballCatagory
        ball.physicsBody?.contactTestBitMask = PhysicsCatagories.switchCatagory
        ball.physicsBody?.collisionBitMask = PhysicsCatagories.none
        addChild(ball)
     }
    
    //Color Switch rotation
    func turnWheel() {
        if let newState = SwitchState(rawValue: switchState.rawValue + 1) {
            switchState = newState
        } else {
            switchState = .red
        }
        
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
    }
    
    //Game Over w/ transition
    func gameOver() {
        UserDefaults.standard.set(score, forKey: "Recent Score")
        if score > UserDefaults.standard.integer(forKey: "Highscore") {
            UserDefaults.standard.set(score, forKey: "Highscore")
        }
        
        let menuScene = MenuScene(size: view!.bounds.size)
         DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.view?.presentScene(menuScene)
         })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()
    }
    
}

//Contact Logic for ball and colorswitch
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCatagories.ballCatagory | PhysicsCatagories.switchCatagory {
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode{
                if currentColorIndex == switchState.rawValue {
                    run(SKAction.playSoundFileNamed("bling", waitForCompletion: false))
                    score += 1
                    updateScoreLabel()
                    ball.run(SKAction.fadeOut(withDuration: 0.25), completion: {ball.removeFromParent()
                        self.spawnBall()
                    })
                } else {
                    ball.physicsBody?.collisionBitMask = PhysicsCatagories.switchCatagory | PhysicsCatagories.ballCatagory
                    ball.physicsBody?.restitution = 0.7
                    gameOver()
                    
                }
            }
        }
    }
}
