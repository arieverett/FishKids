//
//  FeedFrenzyScene.swift
//  FishKids
//
//  Created by Ari Everett on 4/26/26.
//

import SpriteKit

class FeedFrenzyScene: SKScene, SKPhysicsContactDelegate {

    var player: SKSpriteNode!
    var food: SKShapeNode!
    var scoreLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    var timeLeft = 30 {
        didSet {
            timerLabel.text = "Time: \(timeLeft)"
        }
    }

    var gameIsOver = false

    struct PhysicsCategory {
        static let player: UInt32 = 0x1 << 0
        static let food: UInt32 = 0x1 << 1
    }

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.systemTeal

        physicsWorld.contactDelegate = self

        makePlayer()
        makeFood()
        makeScoreLabel()
        makeTimerLabel()
        startTimer()
    }

    func makePlayer() {
        player = SKSpriteNode(color: .orange, size: CGSize(width: 40, height: 40))
        player.position = CGPoint(x: frame.midX, y: frame.midY)
        player.zPosition = 5

        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.food
        player.physicsBody?.collisionBitMask = 0

        addChild(player)
    }

    func makeFood() {
        food = SKShapeNode(circleOfRadius: 14)
        food.fillColor = .yellow
        food.strokeColor = .white
        food.lineWidth = 3
        food.zPosition = 4

        food.physicsBody = SKPhysicsBody(circleOfRadius: 14)
        food.physicsBody?.isDynamic = false
        food.physicsBody?.categoryBitMask = PhysicsCategory.food

        addChild(food)
        moveFoodToRandomPosition()
    }

    func makeScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = .white
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 24, y: frame.height - 70)
        scoreLabel.zPosition = 10

        addChild(scoreLabel)
    }

    func makeTimerLabel() {
        timerLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        timerLabel.text = "Time: 30"
        timerLabel.fontSize = 24
        timerLabel.fontColor = .white
        timerLabel.horizontalAlignmentMode = .right
        timerLabel.position = CGPoint(x: frame.width - 24, y: frame.height - 70)
        timerLabel.zPosition = 10

        addChild(timerLabel)
    }

    func startTimer() {
        let wait = SKAction.wait(forDuration: 1.0)

        let countdown = SKAction.run { [weak self] in
            guard let self = self else { return }

            if self.timeLeft > 0 {
                self.timeLeft -= 1
            } else {
                self.endGame()
            }
        }

        let sequence = SKAction.sequence([wait, countdown])
        run(SKAction.repeatForever(sequence), withKey: "timer")
    }

    func moveFoodToRandomPosition() {
        let padding: CGFloat = 50

        let randomX = CGFloat.random(in: padding...(frame.width - padding))
        let randomY = CGFloat.random(in: padding...(frame.height - padding))

        food.position = CGPoint(x: randomX, y: randomY)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard gameIsOver == false else {
            restartGame()
            return
        }

        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        movePlayer(to: location)
    }

    func movePlayer(to point: CGPoint) {
        let moveAction = SKAction.move(to: point, duration: 0.5)
        player.run(moveAction)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard gameIsOver == false else { return }

        score += 1
        moveFoodToRandomPosition()
    }

    func endGame() {
        gameIsOver = true
        removeAction(forKey: "timer")
        player.removeAllActions()

        gameOverLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        gameOverLabel.text = "Game Over! Tap to Restart"
        gameOverLabel.fontSize = 26
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLabel.zPosition = 20

        addChild(gameOverLabel)
    }

    func restartGame() {
        removeAllChildren()
        removeAllActions()

        score = 0
        timeLeft = 30
        gameIsOver = false

        didMove(to: view!)
    }
}
