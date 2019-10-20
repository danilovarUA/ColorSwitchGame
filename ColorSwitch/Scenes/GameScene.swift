import SpriteKit

enum playColors{
    static let colors = [
        UIColor(displayP3Red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(displayP3Red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(displayP3Red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(displayP3Red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)]
}
enum SwitchState: Int{
    case red, green, yellow, blue
}

class GameScene: SKScene {
    var colorSwitch: SKSpriteNode!
    var switchState = SwitchState.red
    var currentColorIndex: Int?
    var scoreLabel = SKLabelNode(text: "0")
    var score = 0
    override func didMove(to view: SKView) {
        layoutScene()
    }
    
    func layoutScene(){
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        setupPhysics()
        addColorSwitch()
        
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
        
        spawnBall()
    }
    
    func updateLabel(){
        scoreLabel.text = String(score)
    }
    
    func spawnBall(){
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"),
                                color: playColors.colors[currentColorIndex!],
                                size: CGSize(width: 30.0, height: 30.0))
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.zPosition = ZPositions.ball
        ball.position = CGPoint(x: frame.midX, y: frame.maxY-ball.size.width*2) //  ball is covered by the front camera without moving it down:)
        addChild(ball)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody!.categoryBitMask = PhysicsConstants.ballCategory
        ball.physicsBody!.contactTestBitMask = PhysicsConstants.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsConstants.none
    }
    
    func addColorSwitch(){
        colorSwitch = SKSpriteNode(imageNamed: "ColorSwitch")
        colorSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.width)
        addChild(colorSwitch)
        colorSwitch.zPosition = ZPositions.colorSwitch
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2)
        colorSwitch.physicsBody!.categoryBitMask = PhysicsConstants.switchCategory
        colorSwitch.physicsBody!.isDynamic = false
    }
    
    func setupPhysics(){
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)
        physicsWorld.contactDelegate = self
    }
    
    func turnWheel() {
        if let newState = SwitchState(rawValue: switchState.rawValue + 1){
            switchState = newState
        } else{
            switchState = .red
        }
        
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()
    }
    
    func gameOver(){
        UserDefaults.standard.set(score, forKey: "RecentScore")
        if score > UserDefaults.standard.integer(forKey: "Highscore"){
            UserDefaults.standard.set(score, forKey: "Highscore")
        }
        
        let menuScene = MenuScene(size: view!.bounds.size)
        view!.presentScene(menuScene)
    }
    
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if contactMask == PhysicsConstants.ballCategory | PhysicsConstants.switchCategory{
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode: contact.bodyB.node as? SKSpriteNode{
                if currentColorIndex == switchState.rawValue {
                    score += 1
                    run(SKAction.playSoundFileNamed("bling", waitForCompletion: false))
                    updateLabel()
                    ball.run(SKAction.fadeOut(withDuration: 0.25), completion: {
                        ball.removeFromParent()
                        self.spawnBall()
                    })
                }
                else{
                    gameOver()
                }
            }
        }
    }
}
