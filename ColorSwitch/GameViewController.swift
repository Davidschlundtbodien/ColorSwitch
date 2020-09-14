//
//  GameViewController.swift
//  ColorSwitch
//
//  Created by David Schlundt-Bodien on 9/14/20.
//  Copyright © 2020 David Schlundt-Bodien. All rights reserved.
//

import UIKit
import SpriteKit
class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = view as! SKView
            
        let sceneSize = CGSize(width: 1000, height: 2000)
        
        let scene = GameScene(size: sceneSize)
        scene.scaleMode = .aspectFit
        skView.presentScene(scene)
        
        
    }
    
}
