//
//  MenuScene.swift
//  ColorSwitch
//
//  Created by Daniel Varushchyk on 20.10.2019.
//  Copyright © 2019 DanVar. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        addLogo()
        addLabels()
    }
    
    func addLogo(){
        let logo = SKSpriteNode(imageNamed: "logo")
        logo.size = CGSize(width: frame.width/4, height: frame.width/4)
        logo.position = CGPoint(x: frame.midX, y: frame.midY + logo.size.width)
        addChild(logo)
    }
    
    func addLabels(){
        let playLabel = SKLabelNode(text: "Tap to play")
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.fontSize = 50.0
        playLabel.fontColor = UIColor.white
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(playLabel)
        
        let highScoreLabel = SKLabelNode(text: "Highscore: " + String(UserDefaults.standard.integer(forKey: "Highscore")))
        highScoreLabel.fontName = "AvenirNext-Bold"
        highScoreLabel.fontSize = 40.0
        highScoreLabel.fontColor = UIColor.white
        highScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - highScoreLabel.frame.size.height * 4)
        addChild(highScoreLabel)
        
        let lastScoreLabel = SKLabelNode(text: "Recent Score: " + String(UserDefaults.standard.integer(forKey: "RecentScore")))
        lastScoreLabel.fontName = "AvenirNext-Bold"
        lastScoreLabel.fontSize = 40.0
        lastScoreLabel.fontColor = UIColor.white
        lastScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - highScoreLabel.frame.size.height * 2)
        addChild(lastScoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: view!.bounds.size)
        view!.presentScene(gameScene)
    }
}
