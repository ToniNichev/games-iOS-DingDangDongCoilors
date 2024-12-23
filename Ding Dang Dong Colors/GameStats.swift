//
//  GameStats.swift
//  games-Circles Game
//
//  Created by Toni on 12/4/24.
//

struct GameStats {
    let circlesCount = 1
    let minesCount = 1
    
    var score: Int = 0
    var level: Int = 1
    var lives: Int = 3
    var maxLives: Int = 3
    var gameOver: Bool = false
    
    mutating func incrementScore(by points: Int) {
        score += points
    }
    
    mutating func decrementScore(by points: Int) {
        score = max(0, score - points)
    }
    
    mutating func advanceLevel() {
        level += 1
    }
    
    mutating func setGameOver() {
        gameOver = true
    }
    
    mutating func loseLife() {
        lives = max(0, lives - 1)
        if lives == 0 {
            gameOver = true
        }
    }
    
    mutating func gainLife() {
        lives = min(maxLives, lives + 1)
    }
    
    mutating func resetGame() {
        score = 0
        level = 1
        lives = maxLives
        gameOver = false
    }
}
