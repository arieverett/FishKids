//
//  FeedFrenzyScene.swift
//  FishKids
//
//  Created by Ari Everett on 4/21/26.
//

import SpriteKit

class FeedFrenzyScene: SKScene {

    var player: SKSpriteNode!
    var food: SKShapeNode!
    var scoreLabel: SKLabelNode!

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.systemTeal

        makePlayer()
        makeFood()
        makeScoreLabel()
    }

    func makePlayer() {
        player = SKSpriteNode(color: .orange, size: CGSize(width: 40, height: 40))
        player.position = CGPoint(x: frame.midX, y: frame.midY)
        player.zPosition = 5

        addChild(player)
    }

    func makeFood() {
        food = SKShapeNode(circleOfRadius: 14)
        food.fillColor = .yellow
        food.strokeColor = .white
        food.lineWidth = 3
        food.zPosition = 4
        food.name = "food"

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

    func moveFoodToRandomPosition() {
        let padding: CGFloat = 50

        let randomX = CGFloat.random(in: padding...(frame.width - padding))
        let randomY = CGFloat.random(in: padding...(frame.height - padding))

        food.position = CGPoint(x: randomX, y: randomY)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)

        if food.contains(location) {
            score += 1
            moveFoodToRandomPosition()
        } else {
            movePlayer(to: location)
        }
    }

    func movePlayer(to point: CGPoint) {
        let moveAction = SKAction.move(to: point, duration: 0.5)
        player.run(moveAction)
    }
}
