//
//  FeedFrenzyScene.swift
//  FishKids
//
//  Created by Ari Everett on 4/26/26.
//

import SpriteKit
import AVFoundation

class FeedFrenzyScene: SKScene, SKPhysicsContactDelegate {

    enum GameState {
        case playing
        case gameOver
    }

    var gameState: GameState = .playing

    var player: SKLabelNode!
    var food: SKLabelNode!
    var obstacles: [SKLabelNode] = []

    var scoreLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var extraObstacleCount = 0

    var score = 0 {
        didSet {
            scoreLabel?.text = "Score: \(score)"
        }
    }

    var timeLeft = 30 {
        didSet {
            timerLabel?.text = "Time: \(timeLeft)"
        }
    }

    struct PhysicsCategory {
        static let player: UInt32 = 0x1 << 0
        static let food: UInt32   = 0x1 << 1
        static let obstacle: UInt32 = 0x1 << 2
    }

    override func didMove(to view: SKView) {
        startGame()
    }

    func startGame() {
        AudioManager.shared.playMusic(named: "bgMusic")
        
        removeAllChildren()
        removeAllActions()

        backgroundColor = SKColor(red: 0.05, green: 0.55, blue: 0.75, alpha: 1.0)
        physicsWorld.contactDelegate = self

        obstacles.removeAll()
        score = 0
        timeLeft = 30
        extraObstacleCount = 0
        gameState = .playing

        makeBubbles()
        makePlayer()
        makeFood()
        makeObstacles()
        makeScoreLabel()
        makeTimerLabel()
        startTimer()
    }

    func safeGameRect() -> CGRect {
        return CGRect(
            x: 55,
            y: 90,
            width: frame.width - 110,
            height: frame.height - 190
        )
    }

    func randomSafePosition(avoiding nodes: [SKNode], minimumDistance: CGFloat = 85) -> CGPoint {
        let gameRect = safeGameRect()

        for _ in 0..<80 {
            let point = CGPoint(
                x: CGFloat.random(in: gameRect.minX...gameRect.maxX),
                y: CGFloat.random(in: gameRect.minY...gameRect.maxY)
            )

            let tooClose = nodes.contains { node in
                distance(from: point, to: node.position) < minimumDistance
            }

            if !tooClose {
                return point
            }
        }

        return CGPoint(x: gameRect.midX, y: gameRect.midY)
    }

    func distance(from a: CGPoint, to b: CGPoint) -> CGFloat {
        let dx = a.x - b.x
        let dy = a.y - b.y
        return sqrt(dx * dx + dy * dy)
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
        respawnFood()
    }

    func respawnFood() {
        let avoidNodes: [SKNode] = [player] + obstacles
        food.position = randomSafePosition(avoiding: avoidNodes, minimumDistance: 95)
    }

    func makeObstacles() {
        let obstacleEmojis = ["🪨", "🪸", "⚓️", "🦀"]

        for emoji in obstacleEmojis {
            let obstacle = SKLabelNode(text: emoji)
            obstacle.fontSize = 34
            obstacle.zPosition = 4

            obstacle.physicsBody = SKPhysicsBody(circleOfRadius: 18)
            obstacle.physicsBody?.isDynamic = false
            obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle

            addChild(obstacle)

            let avoidNodes: [SKNode] = [player, food] + obstacles
            obstacle.position = randomSafePosition(avoiding: avoidNodes, minimumDistance: 95)

            obstacles.append(obstacle)
        }
    }
    
    func spawnExtraObstacle() {
        let obstacleEmojis = ["🪨", "🪸", "⚓️", "🦀"]
        let emoji = obstacleEmojis.randomElement() ?? "🪨"

        let obstacle = SKLabelNode(text: emoji)
        obstacle.fontSize = 34
        obstacle.zPosition = 4

        obstacle.physicsBody = SKPhysicsBody(circleOfRadius: 18)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle

        addChild(obstacle)

        let avoidNodes: [SKNode] = [player, food] + obstacles
        obstacle.position = randomSafePosition(avoiding: avoidNodes, minimumDistance: 95)

        obstacles.append(obstacle)
    }

    func makeScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = .white
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 95, y: frame.height - 70)
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

        run(SKAction.repeatForever(SKAction.sequence([wait, countdown])), withKey: "timer")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard gameState == .playing else {
            startGame()
            return
        }

        guard let touch = touches.first else { return }
        movePlayer(to: touch.location(in: self))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard gameState == .playing else { return }

        guard let touch = touches.first else { return }
        movePlayer(to: touch.location(in: self))
    }

    func movePlayer(to point: CGPoint) {
        let gameRect = safeGameRect()

        let safePoint = CGPoint(
            x: min(max(point.x, gameRect.minX), gameRect.maxX),
            y: min(max(point.y, gameRect.minY), gameRect.maxY)
        )

        player.removeAction(forKey: "move")
        player.run(SKAction.move(to: safePoint, duration: 0.18), withKey: "move")
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard gameState == .playing else { return }

        let categories = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        // food collision logic block
        if categories == PhysicsCategory.player | PhysicsCategory.food {
            score += 1

            if score % 5 == 0 && extraObstacleCount < 3 {
                spawnExtraObstacle()
                extraObstacleCount += 1
            }
            
            AudioManager.shared.playSFX(named: "eatSound")

            food.removeFromParent()

            let wait = SKAction.wait(forDuration: 0.2)
            let spawn = SKAction.run { [weak self] in
                self?.makeFood()
            }

            run(SKAction.sequence([wait, spawn]))
        }

        // obstacle collision logic block
        if categories == PhysicsCategory.player | PhysicsCategory.obstacle {
            AudioManager.shared.playSFX(named: "trashSound")

            let hitNode = contact.bodyA.categoryBitMask == PhysicsCategory.obstacle
                ? contact.bodyA.node
                : contact.bodyB.node

            if let obstacle = hitNode, let player = player, let food = food {
                let avoidNodes: [SKNode] = [player, food] + obstacles.filter { $0 !== obstacle }
                obstacle.position = randomSafePosition(avoiding: avoidNodes, minimumDistance: 95)
            }
        }
    }

    func endGame() {
        gameState = .gameOver
        removeAction(forKey: "timer")
        player.removeAllActions()

        let previousHighScore = UserDefaults.standard.integer(forKey: "feedFrenzyHighScore")

        if score > previousHighScore {
            UserDefaults.standard.set(score, forKey: "feedFrenzyHighScore")
        }

        let highScore = UserDefaults.standard.integer(forKey: "feedFrenzyHighScore")

        let overlay = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height))
        overlay.fillColor = .black.withAlphaComponent(0.35)
        overlay.strokeColor = .clear
        overlay.position = CGPoint(x: frame.midX, y: frame.midY)
        overlay.zPosition = 15
        addChild(overlay)

        gameOverLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        gameOverLabel.text = "Game Over!"
        gameOverLabel.fontSize = 38
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY + 85)
        gameOverLabel.zPosition = 20
        addChild(gameOverLabel)

        let finalScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        finalScoreLabel.text = "Final Score: \(score)"
        finalScoreLabel.fontSize = 26
        finalScoreLabel.fontColor = .yellow
        finalScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY + 35)
        finalScoreLabel.zPosition = 20
        addChild(finalScoreLabel)

        let highScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        highScoreLabel.text = "High Score: \(highScore)"
        highScoreLabel.fontSize = 24
        highScoreLabel.fontColor = .white
        highScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - 5)
        highScoreLabel.zPosition = 20
        addChild(highScoreLabel)

        let restartLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        restartLabel.text = "Tap to Play Again"
        restartLabel.fontSize = 22
        restartLabel.fontColor = .white
        restartLabel.position = CGPoint(x: frame.midX, y: frame.midY - 60)
        restartLabel.zPosition = 20
        addChild(restartLabel)
    }
}
