//
//  ContentView.swift
//  TapOnCircles
//
//  Created by Toni on 12/3/24.
//

import SwiftUI

struct GameView: View {
    @Binding var gameStats: GameStats
    @State private var circleCount = 5
    @State private var minesCount = 3
    
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
            fixedCircleColor: .black)
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
            minesCount += 1
            
        }
             
    }
}

#Preview {
    @Previewable @State var gameStats = GameStats()
    GameView(gameStats: $gameStats)
}
