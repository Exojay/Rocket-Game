//
//  GameScene.swift
//  Rocket Game
//
//  Created by Carlos Conley on 5/23/19.
//  Copyright © 2019 Carlos Conley. All rights reserved.
//

import SpriteKit
import GameplayKit

var asteroids:[SKSpriteNode] = [SKSpriteNode(),SKSpriteNode(),SKSpriteNode(),SKSpriteNode(),SKSpriteNode(),SKSpriteNode()]

/*var asteroids = [
	[SKSpriteNode(), CGFloat(CGFloat.random(in: 480...1000)), CGFloat(CGFloat.random(in: -640...640))],
	[SKSpriteNode(), CGFloat(CGFloat.random(in: 480...1000)), CGFloat(CGFloat.random(in: -640...640))],
	[SKSpriteNode(), CGFloat(CGFloat.random(in: 480...1000)), CGFloat(CGFloat.random(in: -640...640))],
	[SKSpriteNode(), CGFloat(CGFloat.random(in: 480...1000)), CGFloat(CGFloat.random(in: -640...640))],
	[SKSpriteNode(), CGFloat(CGFloat.random(in: 480...1000)), CGFloat(CGFloat.random(in: -640...640))],
	[SKSpriteNode(), CGFloat(CGFloat.random(in: 480...1000)), CGFloat(CGFloat.random(in: -640...640))],
	]
*/
var a_vel:CGFloat = -6.0
var gameOver:Bool = true

var score:Int = 0
let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
	score += 1
	if score % 20 == 0 {
		a_vel *= CGFloat(1.2)
	}
}

class GameScene: SKScene {
	
	var label = SKLabelNode()
	var scoreLabel = SKLabelNode()
	var player = SKSpriteNode()
	var button = SKNode()
	var background = SKSpriteNode()
	var backgroundOther = SKSpriteNode()
	
	
	
	override func didMove(to view: SKView) {
		
		player = self.childNode(withName: "player") as! SKSpriteNode
		background = self.childNode(withName: "background") as! SKSpriteNode
		backgroundOther = self.childNode(withName: "backgroundOther") as! SKSpriteNode
		scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
		label = self.childNode(withName: "startLabel") as! SKLabelNode
		button = self.childNode(withName: "startButton") as! SKNode
		for i in 0...(asteroids.count - 1) {
			asteroids[i] = self.childNode(withName: "asteroid" + String(i)) as! SKSpriteNode
		}
		
		
	}

	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			
			let location = touch.location(in: self)
			
			if (location.y >= button.position.y - 50) && (location.y <= button.position.y + 50) && (location.x >= button.position.x - 50) && (location.x <= button.position.x + 50) && gameOver == true {
				gameOver = false
				for i in 0...(asteroids.count - 1) {
					asteroids[i].run(SKAction.unhide())
				}
				player.run(SKAction.unhide())
				button.run(SKAction.hide())
				label.run(SKAction.hide())
				label.text = "Game Over"
				score = 0;
			}
			player.run(SKAction.moveTo(y: location.y, duration: 0.1))
			player.run(SKAction.moveTo(x: location.x, duration: 0.1))
			
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			
			let location = touch.location(in: self)
			
			player.run(SKAction.moveTo(y: location.y, duration: 0.1))
			player.run(SKAction.moveTo(x: location.x, duration: 0.1))
			
		}
	}
	
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
		if gameOver == false {
			scoreLabel.text = "Score: " + String(score)
			timer
			player.run(SKAction.unhide())
			for i in 0...(asteroids.count - 1) {
				
				asteroids[i].run(SKAction.moveBy(x: a_vel, y: 0, duration: 0))

				if asteroids[i].position.x < CGFloat(-470) {
					asteroids[i].position.x = CGFloat.random(in: 480 ... 900)
					asteroids[i].position.y = CGFloat.random(in: -640...640)
				}

				if (player.position.x + 25 >= asteroids[i].position.x - 50) && (player.position.x - 25 <= asteroids[i].position.x + 50) && (player.position.y + 50 >= asteroids[i].position.y - 50) && (player.position.y - 50 <= asteroids[i].position.y + 50) {
					gameOver = true
					
					
					player.run(SKAction.hide())
					button.run(SKAction.unhide())
					label.run(SKAction.unhide())
					
					for i in 0...(asteroids.count - 1) {
						asteroids[i].run(SKAction.hide())
						asteroids[i].position.x = CGFloat.random(in: 480...1000)
						asteroids[i].position.y = CGFloat.random(in: -640...640)
					}
					
	
				}
			}
			background.run(SKAction.moveBy(x: a_vel * 0.5, y: 0, duration: 0))
			backgroundOther.run(SKAction.moveBy(x: a_vel * 0.5, y: 0, duration: 0))
			if background.position.x < CGFloat(-1709) {
				background.position.x = 3627
			}
			if backgroundOther.position.x < CGFloat(-1709) {
				backgroundOther.position.x = 3627
			}
		}
	}
}

