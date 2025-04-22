//
//  GameStats.swift
//  games-Circles Game
//
//  Created by Toni on 12/4/24.
//

import SwiftUI
import Combine
import GameKit

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
    @Published var timeRemaining: Int = 15  // Starting with 15 seconds
    @Published var isTimerRunning: Bool = false
    
    // Game Center properties
    @Published var gameCenterEnabled: Bool = false
    @Published var showLeaderboard: Bool = false
    
    // Leaderboard IDs - using your specific weekly leaderboard ID
    let weeklyLeaderboardID = "ding_dang_dong_colors_weekly"
    
    private var timer: AnyCancellable?
    
    init() {
        authenticateGameCenter()
    }
    
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
        
        // Submit level to Game Center
        if gameCenterEnabled {
            submitLevelToGameCenter()
        }
    }
    
    func setGameOver() {
        gameOver = true
        stopTimer()
        
        // Submit final score to Game Center
        if gameCenterEnabled {
            submitScoreToGameCenter()
        }
    }
    
    func loseLife() {
        lives = max(0, lives - 1)
        if lives == 0 {
            gameOver = true
            stopTimer()
            
            // Submit final score to Game Center
            if gameCenterEnabled {
                submitScoreToGameCenter()
            }
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
                    // Time's up - end the game
                    self.endGame()
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
    
    // New method to end the game when time runs out
    func endGame() {
        gameOver = true
        stopTimer()
        
        // Submit final score to Game Center
        if gameCenterEnabled {
            submitScoreToGameCenter()
        }
    }
    
    // Calculate time limit based on level
    func getLevelTimeLimit() -> Int {
        // Start with 15 seconds at level 1, decrease by 1 second per level
        // with a minimum of 8 seconds for higher levels
        return max(8, 15 - (level - 1))
    }
    
    // MARK: - Game Center Methods
    
    func authenticateGameCenter() {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            // If a view controller was provided, present it
            if let viewController = viewController {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootViewController = windowScene.windows.first?.rootViewController {
                    rootViewController.present(viewController, animated: true)
                }
            } else if GKLocalPlayer.local.isAuthenticated {
                // Player is authenticated
                self.gameCenterEnabled = true
                print("Game Center: Player authenticated as \(GKLocalPlayer.local.displayName)")
                
                // Configure Game Center
                GKAccessPoint.shared.location = .topLeading
                GKAccessPoint.shared.isActive = true
                
                // Check if we can load the leaderboard
                self.loadWeeklyLeaderboard()
            } else {
                // Player is not authenticated
                self.gameCenterEnabled = false
                
                if let error = error {
                    print("Game Center authentication error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Load the weekly leaderboard to verify it exists
    func loadWeeklyLeaderboard() {
        GKLeaderboard.loadLeaderboards(IDs: [weeklyLeaderboardID]) { leaderboards, error in
            if let error = error {
                print("Error loading weekly leaderboard: \(error.localizedDescription)")
                return
            }
            
            if let leaderboards = leaderboards, leaderboards.isEmpty {
                print("Warning: No leaderboards found with ID '\(self.weeklyLeaderboardID)'")
            } else {
                print("Successfully loaded weekly leaderboard")
            }
        }
    }
    
    // Submit the player's score to the weekly leaderboard
    func submitScoreToGameCenter() {
        guard gameCenterEnabled else {
            print("Cannot submit score: Game Center not enabled")
            return
        }
        
        let scoreReporter = GKScore(leaderboardIdentifier: weeklyLeaderboardID)
        scoreReporter.value = Int64(score)
        
        GKScore.report([scoreReporter]) { error in
            if let error = error {
                print("Error submitting score: \(error.localizedDescription)")
            } else {
                print("Score \(self.score) submitted successfully to weekly leaderboard")
            }
        }
    }
    
    // Submit the player's level to Game Center
    func submitLevelToGameCenter() {
        guard gameCenterEnabled else { return }
        
        // Note: If you want to track level as a separate leaderboard,
        // you would need to create another leaderboard in App Store Connect
        // For now, we're just submitting the score to the weekly leaderboard
        submitScoreToGameCenter()
    }
    
    // Open the Game Center leaderboard
    func showGameCenter() {
        showLeaderboard = true
    }
}
