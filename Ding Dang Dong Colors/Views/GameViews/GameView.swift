//
//  ContentView.swift
//  TapOnCircles
//
//  Created by Toni on 12/3/24.
//

import SwiftUI

struct GameView: View {
    @Binding var gameStats: GameStats

    @State private var circleCount : Int = 1
    @State private var minesCount : Int = 1
    
    var movementSpeed: Double {
        max(0.5, 2.5 - Double(gameStats.level) * 0.3) // Faster speed as score increases
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                createBackground()
                createCircles()
                createMines()
                createScoreView().opacity(0.8)
                VStack {
                    Spacer()
                    Text("\(circleCount)")
                }
            }
            .onAppear() {
                resetGame()
            }
            .onChange(of: gameStats.gameOver, initial: true) {
                if gameStats.gameOver {
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
        VStack {
            ScoreLevelView(
                score: gameStats.score,
                level: gameStats.level,
                lives: gameStats.lives,
                maxLives: gameStats.maxLives,
                gradientColors: [.red, .green])
            Spacer()
            
        }
    }
    
    func createMines() -> some View {
        MovingCirclesView(
            circlesCount: minesCount,
            movementInterval: movementSpeed,
            minRadius: 30,
            maxRadius: 100,
            animationType: .linear(duration: movementSpeed),
            removeCircleOnTapped: false,
            fixedCircleColor: .black
        )
        { circle in
            gameStats.decrementScore(by: circle.points)
            gameStats.loseLife()
            //if score < 0 { score = 0 }
        } allCirclesCleared: {
            
        }
    }
    
    func createCircles() -> some View {
        return MovingCirclesView(
            circlesCount: circleCount,
            movementInterval: movementSpeed,
            minRadius: 30,
            maxRadius: 100,
            animationType: .linear(duration: movementSpeed)
        )
        { circle in
            gameStats.incrementScore(by: circle.points)
            
        } allCirclesCleared: {
            gameStats.advanceLevel()
            circleCount =  gameStats.circlesCount +  (gameStats.level - 1)
            minesCount += 1
            
        }
             
    }
    
    func resetGame() {
        circleCount = gameStats.circlesCount
        minesCount = gameStats.minesCount
        gameStats.resetGame()
    }
}

#Preview {
    @Previewable @State var gameStats = GameStats()
    GameView(gameStats: $gameStats)
}
