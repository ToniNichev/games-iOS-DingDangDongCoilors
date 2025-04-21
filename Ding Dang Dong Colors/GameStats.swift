//
//  GameStats.swift
//  games-Circles Game
//
//  Created by Toni on 12/4/24.
//

import SwiftUI
import Combine

class GameStats: ObservableObject {
    // Original properties
    let circlesCount = 3
    let minesCount = 3
    
    @Published var score: Int = 0
    @Published var level: Int = 1
    @Published var lives: Int = 3
    @Published var maxLives: Int = 3
    @Published var gameOver: Bool = false
    
    // Timer properties
    @Published var timeRemaining: Int = 30
    @Published var isTimerRunning: Bool = false
    
    private var timer: AnyCancellable?
    
    // Original methods
    func incrementScore(by points: Int) {
        score += points
    }
    
    func decrementScore(by points: Int) {
        score = max(0, score - points)
    }
    
    func advanceLevel() {
        level += 1
        // Reset timer for the new level
        timeRemaining = getLevelTimeLimit()
        startTimer()
    }
    
    func setGameOver() {
        gameOver = true
        stopTimer()
    }
    
    func loseLife() {
        lives = max(0, lives - 1)
        if lives == 0 {
            gameOver = true
            stopTimer()
        }
    }
    
    func gainLife() {
        lives = min(maxLives, lives + 1)
    }
    
    func resetGame() {
        score = 0
        level = 1
        lives = maxLives
        gameOver = false
        
        // Reset and start timer
        timeRemaining = getLevelTimeLimit()
        startTimer()
    }
    
    // Timer-related methods
    func startTimer() {
        isTimerRunning = true
        timer?.cancel()
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    // Time's up - lose a life
                    self.loseLife()
                    if !self.gameOver {
                        // If still alive, reset timer for current level
                        self.timeRemaining = self.getLevelTimeLimit()
                    }
                }
            }
    }
    
    func stopTimer() {
        isTimerRunning = false
        timer?.cancel()
        timer = nil
    }
    
    func pauseTimer() {
        isTimerRunning = false
        timer?.cancel()
    }
    
    func resumeTimer() {
        if !isTimerRunning && !gameOver {
            startTimer()
        }
    }
    
    // Calculate time limit based on level
    func getLevelTimeLimit() -> Int {
        // Start with 30 seconds at level 1, decrease by 2 seconds per level
        // with a minimum of 15 seconds for higher levels
        return max(15, 30 - (level - 1) * 2)
    }
}
