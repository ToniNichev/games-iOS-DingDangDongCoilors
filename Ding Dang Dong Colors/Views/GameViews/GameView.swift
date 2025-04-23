//
//  ContentView.swift
//  TapOnCircles
//
//  Created by Toni on 12/3/24.
//

import SwiftUI
import GoogleMobileAds


struct GameView: View {
    @ObservedObject var gameStats: GameStats
    
    // Add the interstitial ad manager
    @StateObject private var adManager = InterstitialAdManager()

    @State private var circleCount : Int = 1
    @State private var minesCount : Int = 1
    
    @State private var minCircleRadius = 50.0
    @State private var maxCircleRadius = 100.0
    
    @State private var minMineRadius = 50.0
    @State private var maxMineRadius = 100.0
    
    // Timer animation properties
    @State private var timerProgressColor: Color = .green
    
    // Heart animation properties
    @State private var showHeartAnimation: Bool = false
    @State private var heartCollectedPosition: CGPoint = .zero
    
    // Clock animation properties
    @State private var showClockAnimation: Bool = false
    @State private var timeBonusAmount: Int = 0
                
    var movementSpeed: Double {
        max(0.5, 2.5 - Double(gameStats.level) * 0.3) // Faster speed as score increases
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                createBackground()
                
                // Main content layout
                VStack(spacing: 0) {
                    // Timer at the very top
                    createTimerView(geometry: geometry)
                        .padding(.top, 10)
                    
                    // Score view below timer
                    createScoreView()
                        .opacity(0.8)
                        .padding(.top, 10)
                    
                    // Game area takes remaining space
                    ZStack {
                        createCircles()
                        createMines()
                        
                        // Add the falling heart view
                        FallingHeartView(gameLevel: $gameStats.level) {
                            // Handle heart tapped - add a life
                            gameStats.gainLife()
                            
                            // Visual feedback for collecting a heart
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                                showHeartAnimation = true
                            }
                            
                            // Hide the animation after a delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                showHeartAnimation = false
                            }
                        }
                        
                        // Add the falling clock view
                        FallingClockView(gameLevel: $gameStats.level) { timeBonus in
                            // Handle clock tapped - add time to timer
                            gameStats.addTime(seconds: timeBonus)
                            timeBonusAmount = timeBonus
                            
                            // Visual feedback for collecting a clock
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                                showClockAnimation = true
                            }
                            
                            // Hide the animation after a delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                showClockAnimation = false
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                // Visual feedback when collecting a heart
                if showHeartAnimation {
                    ZStack {
                        // Heart particle effect
                        HeartParticleView(position: CGPoint(x: geometry.size.width/2, y: geometry.size.height/2))                        
                        // Text notification
                        VStack {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.red)
                            Text("+1 Life!")
                                .font(.headline)
                                .foregroundColor(.white)
                                .shadow(radius: 3)
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                
                // Visual feedback when collecting a clock
                if showClockAnimation {
                    ZStack {
                        // Clock particle effect
                        ClockParticleView(
                            position: CGPoint(x: geometry.size.width/2, y: geometry.size.height/2),
                            timeBonus: timeBonusAmount
                        )
                        
                        // Text notification
                        VStack {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                            Text("+\(timeBonusAmount)s")
                                .font(.headline)
                                .foregroundColor(.white)
                                .shadow(radius: 3)
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
            .onAppear {
                circleCount = gameStats.circlesCount
                minesCount = gameStats.minesCount
                gameStats.startTimer()
                // Load the interstitial ad when the view appears
                adManager.loadAd()
            }
            .onChange(of: gameStats.timeRemaining) {
                // Update timer color based on remaining time
                updateTimerColor()
            }
            .onChange(of: gameStats.gameOver, initial: true) {
                if gameStats.gameOver {
                    // Show the interstitial ad when game is over
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        adManager.showAd()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        // delay reseting the game so it won't show more circles during fade effect
                        resetGame()
                    }
                }
            }
        }
    }
    
    func createBackground() -> some View {
        // Background gradient
        LinearGradient(
            gradient: Gradient(colors: [.red, .green]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    func createScoreView() -> some View {
        ScoreLevelView(
            score: gameStats.score,
            level: gameStats.level,
            lives: gameStats.lives,
            maxLives: gameStats.maxLives,
            gradientColors: [.red, .green])
    }
    
    func createTimerView(geometry: GeometryProxy) -> some View {
        HStack {
            // Timer progress bar
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 10)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                Rectangle()
                    .frame(width: getTimerWidth(geometry: geometry.size.width - 110), height: 10)
                    .foregroundColor(timerProgressColor)
                    .animation(.linear, value: gameStats.timeRemaining)
            }
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .frame(maxWidth: .infinity)
            
            // Time remaining text
            Text("\(gameStats.timeRemaining)s")
                .font(.headline)
                .foregroundColor(.white)
                .padding(8)
                .background(timerProgressColor)
                .cornerRadius(10)
                .shadow(radius: 3)
        }
        .padding(.horizontal)
    }
    
    func getTimerWidth(geometry: CGFloat) -> CGFloat {
        let maxWidth = geometry - 32 // Account for padding
        let baseTime = Double(gameStats.getLevelTimeLimit())
        let remainingPercentage = Double(gameStats.timeRemaining) / baseTime
        return maxWidth * CGFloat(remainingPercentage)
    }
    
    func updateTimerColor() {
        let baseTime = Double(gameStats.getLevelTimeLimit())
        let percentage = Double(gameStats.timeRemaining) / baseTime
        
        if percentage > 0.6 {
            timerProgressColor = .green
        } else if percentage > 0.3 {
            timerProgressColor = .yellow
        } else {
            timerProgressColor = .red
        }
    }
    
    func createMines() -> some View {
        MovingCirclesView(
            circlesCount: minesCount,
            movementInterval: movementSpeed,
            minRadius: minMineRadius,
            maxRadius: maxMineRadius,
            animationType: .linear(duration: movementSpeed),
            removeCircleOnTapped: false,
            fixedCircleColor: .black
        )
        { circle in
            gameStats.decrementScore(by: circle.points)
            gameStats.loseLife()
        } allCirclesCleared: {
            // Nothing to do when all mines are cleared (which won't happen)
        }
    }
    
    func createCircles() -> some View {
        return MovingCirclesView(
            circlesCount: circleCount,
            movementInterval: movementSpeed,
            minRadius: minCircleRadius,
            maxRadius: maxMineRadius,
            animationType: .linear(duration: movementSpeed)
        )
        { circle in
            // circle tapped
            gameStats.incrementScore(by: circle.points)
            
        } allCirclesCleared: {
            // Level up
            gameStats.advanceLevel()
            circleCount = gameStats.circlesCount + (gameStats.level - 1)
            minesCount = gameStats.minesCount + (gameStats.level - 1)
        }
    }
    
    func resetGame() {
        circleCount = gameStats.circlesCount
        minesCount = gameStats.minesCount
        // gameStats.resetGame()
    }
}

#Preview {
    @Previewable let previewGameStats = GameStats()
    GameView(gameStats: previewGameStats)
}
