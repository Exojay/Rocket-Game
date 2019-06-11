//
//  GameScene.swift
//  Rocket Game
//
//  Created by Carlos Conley on 5/23/19.
//  Copyright © 2019 Carlos Conley. All rights reserved.
//

import SpriteKit
import GameplayKit

// Array of asteroid nodes
var asteroids:[SKSpriteNode] = [SKSpriteNode(),SKSpriteNode(),SKSpriteNode(),SKSpriteNode(),SKSpriteNode(),SKSpriteNode()]

var a_vel:CGFloat = -6.0 // Speed of the asteroids
var gameOver:Bool = true

var score:Int = 0
let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
	score += 1
	if score % 20 == 0 {
		a_vel *= CGFloat(1.2)
	}
}

class GameScene: SKScene {
	// Declare the nodes
	var label = SKLabelNode()
	var scoreLabel = SKLabelNode()
	var player = SKSpriteNode()
	var button = SKNode()
	var background = SKSpriteNode()
	var backgroundOther = SKSpriteNode()
	let backgroundMusic = SKAudioNode(fileNamed: "spacemusic.mp3")
	
	
	
	override func didMove(to view: SKView) {
		// Link the nodes in code to the nodes in the game scene
		player = self.childNode(withName: "player") as! SKSpriteNode
		background = self.childNode(withName: "background") as! SKSpriteNode
		backgroundOther = self.childNode(withName: "backgroundOther") as! SKSpriteNode
		scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
		label = self.childNode(withName: "startLabel") as! SKLabelNode
		button = self.childNode(withName: "startButton") as! SKNode
		// Adds music to the game
		self.addChild(backgroundMusic)
		backgroundMusic.run(SKAction.stop())
		player.run(SKAction.hide())
		for i in 0...(asteroids.count - 1) {
			asteroids[i] = self.childNode(withName: "asteroid" + String(i)) as! SKSpriteNode
		}
		
		
	}

	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			
			let location = touch.location(in: self)
			// Hit regestration for the button
			if (location.y >= button.position.y - 270) && (location.y <= button.position.y + 270) && (location.x >= button.position.x - 520) && (location.x <= button.position.x + 520) && gameOver == true {
				gameOver = false
				for i in 0...(asteroids.count - 1) {
					asteroids[i].run(SKAction.unhide())
				}
				// Reset score, speed, and music and hide objects
				player.run(SKAction.unhide())
				button.run(SKAction.hide())
				label.run(SKAction.hide())
				label.text = "Game Over"
				score = 0;
				backgroundMusic.run(SKAction.stop())
				backgroundMusic.run(SKAction.play())
				
				a_vel = -6.0
			}
			// Move the ship to where the player is touching
			player.run(SKAction.moveTo(y: location.y, duration: 0.1))
			player.run(SKAction.moveTo(x: location.x, duration: 0.1))
			
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			
			let location = touch.location(in: self)
			// Move the ship to where the player is touching
			player.run(SKAction.moveTo(y: location.y, duration: 0.1))
			player.run(SKAction.moveTo(x: location.x, duration: 0.1))
			
		}
	}
	
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
		if gameOver == false {
			scoreLabel.text = "Score: " + String(score)
			// Calls the timer if the game is playing
			timer
			player.run(SKAction.unhide())
			for i in 0...(asteroids.count - 1) {
				
				asteroids[i].run(SKAction.moveBy(x: a_vel, y: 0, duration: 0))
				// If asteroid is off screen, move it to a random x and y value
				if asteroids[i].position.x < CGFloat(-470) {
					asteroids[i].position.x = CGFloat.random(in: 480 ... 900)
					asteroids[i].position.y = CGFloat.random(in: -640...640)
				}
				// Hit regestration for asteroids and rocket ship
				if (player.position.x + 23 >= asteroids[i].position.x - 45) && (player.position.x - 23 <= asteroids[i].position.x + 45) && (player.position.y + 45 >= asteroids[i].position.y - 45) && (player.position.y - 45 <= asteroids[i].position.y + 45) {
					gameOver = true
					
					run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: true))
					
					player.run(SKAction.hide())
					button.run(SKAction.unhide())
					label.run(SKAction.unhide())
					// Reset the positions of the asteroids in random positions
					for i in 0...(asteroids.count - 1) {
						asteroids[i].run(SKAction.hide())
						asteroids[i].position.x = CGFloat.random(in: 480...1000)
						asteroids[i].position.y = CGFloat.random(in: -640...640)
					}
					
	
				}
			}
			// Move the background at 1/2 the rate of the asteroids
			background.run(SKAction.moveBy(x: a_vel * 0.5, y: 0, duration: 0))
			backgroundOther.run(SKAction.moveBy(x: a_vel * 0.5, y: 0, duration: 0))
			// If background is off screen, reset the position
			if background.position.x < CGFloat(-1709) {
				background.position.x = 3627
			}
			if backgroundOther.position.x < CGFloat(-1709) {
				backgroundOther.position.x = 3627
			}
		}
	}
}

