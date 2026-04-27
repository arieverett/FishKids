//
//  FeedFrenzyScene.swift
//  FishKids
//
//  Created by Ari Everett on 4/26/26.
//

import SpriteKit
import AVFoundation

class FeedFrenzyScene: SKScene, SKPhysicsContactDelegate {

    var player: SKLabelNode!
    var food: SKLabelNode!
    var obstacles: [SKLabelNode] = []

    var scoreLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!

    var eatAudioPlayer: AVAudioPlayer?
    var trashAudioPlayer: AVAudioPlayer?

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
        static let obstacle: UInt32 = 0x1 << 2
    }

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.05, green: 0.55, blue: 0.75, alpha: 1.0)

        physicsWorld.contactDelegate = self

        loadSounds()
        makeBubbles()
        makePlayer()
        makeFood()
        makeObstacles()
        makeScoreLabel()
        makeTimerLabel()
        startTimer()
    }

    func loadSounds() {
        if let eatAsset = NSDataAsset(name: "eatSound") {
            eatAudioPlayer = try? AVAudioPlayer(data: eatAsset.data)
            eatAudioPlayer?.prepareToPlay()
        }

        if let trashAsset = NSDataAsset(name: "trashSound") {
            trashAudioPlayer = try? AVAudioPlayer(data: trashAsset.data)
            trashAudioPlayer?.prepareToPlay()
        }
    }

    func makeBubbles() {
        for _ in 0..<18 {
            let bubble = SKShapeNode(circleOfRadius: CGFloat.random(in: 4...12))
            bubble.fillColor = .clear
            bubble.strokeColor = .white.withAlphaComponent(0.45)
            bubble.lineWidth = 2
            bubble.position = CGPoint(
                x: CGFloat.random(in: 20...frame.width - 20),
                y: CGFloat.random(in: 20...frame.height - 20)
            )
            bubble.zPosition = 1
            addChild(bubble)

            let moveUp = SKAction.moveBy(x: 0, y: frame.height + 50, duration: Double.random(in: 8...14))
            let reset = SKAction.moveTo(y: -40, duration: 0)
            let sequence = SKAction.sequence([moveUp, reset])
            bubble.run(SKAction.repeatForever(sequence))
        }
    }

    func makePlayer() {
        player = SKLabelNode(text: "🐠")
        player.fontSize = 46
        player.position = CGPoint(x: frame.midX, y: frame.midY)
        player.zPosition = 5

        player.physicsBody = SKPhysicsBody(circleOfRadius: 22)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.food | PhysicsCategory.obstacle
        player.physicsBody?.collisionBitMask = 0

        addChild(player)
    }

    func makeFood() {
        food = SKLabelNode(text: "🍤")
        food.fontSize = 34
        food.zPosition = 4

        food.physicsBody = SKPhysicsBody(circleOfRadius: 17)
        food.physicsBody?.isDynamic = false
        food.physicsBody?.categoryBitMask = PhysicsCategory.food

        addChild(food)
        moveNodeToRandomPosition(food)
    }

    func makeObstacles() {
        obstacles.removeAll()

        let obstacleEmojis = ["🪨", "🪸", "⚓️", "🦀"]

        for emoji in obstacleEmojis {
            let obstacle = SKLabelNode(text: emoji)
            obstacle.fontSize = 34
            obstacle.zPosition = 4

            obstacle.physicsBody = SKPhysicsBody(circleOfRadius: 18)
            obstacle.physicsBody?.isDynamic = false
            obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle

            addChild(obstacle)
            moveNodeToRandomPosition(obstacle)
            obstacles.append(obstacle)
        }
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

    func moveNodeToRandomPosition(_ node: SKNode) {
        let padding: CGFloat = 75

        let randomX = CGFloat.random(in: padding...(frame.width - padding))
        let randomY = CGFloat.random(in: padding...(frame.height - padding))

        node.position = CGPoint(x: randomX, y: randomY)
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
        let moveAction = SKAction.move(to: point, duration: 0.45)
        player.run(moveAction)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard gameIsOver == false else { return }

        let categories = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        if categories == PhysicsCategory.player | PhysicsCategory.food {
            score += 1
            eatAudioPlayer?.currentTime = 0
            eatAudioPlayer?.play()
            moveNodeToRandomPosition(food)
        }

        if categories == PhysicsCategory.player | PhysicsCategory.obstacle {
            score -= 1
            trashAudioPlayer?.currentTime = 0
            trashAudioPlayer?.play()

            let hitNode = contact.bodyA.categoryBitMask == PhysicsCategory.obstacle
                ? contact.bodyA.node
                : contact.bodyB.node

            if let obstacle = hitNode {
                moveNodeToRandomPosition(obstacle)
            }
        }
    }

    func endGame() {
        gameIsOver = true
        removeAction(forKey: "timer")
        player.removeAllActions()

        gameOverLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        gameOverLabel.text = "Game Over! Tap to Restart"
        gameOverLabel.fontSize = 24
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLabel.zPosition = 20

        addChild(gameOverLabel)
    }

    func restartGame() {
        removeAllChildren()
        removeAllActions()

        obstacles.removeAll()
        score = 0
        timeLeft = 30
        gameIsOver = false

        didMove(to: view!)
    }
}
