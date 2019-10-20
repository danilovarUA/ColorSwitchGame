import SpriteKit

class GameScene: SKScene {
    var colorSwitch: SKSpriteNode!

    override func didMove(to view: SKView) {
        layoutScene()
    }
    
    func layoutScene(){
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        setupPhysics()
        addColorSwitch()
        spawnBall()
    }
    
    func spawnBall(){
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSize(width: 30.0, height: 30.0)
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
        
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2)
        colorSwitch.physicsBody!.categoryBitMask = PhysicsConstants.switchCategory
        colorSwitch.physicsBody!.isDynamic = false
    }
    
    func setupPhysics(){
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)
        physicsWorld.contactDelegate = self
    }
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if contactMask == PhysicsConstants.ballCategory | PhysicsConstants.switchCategory{
            print("Kontankt!")
        }
    }
}
