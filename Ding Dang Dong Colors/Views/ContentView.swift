//
//  ContentView.swift
//  Ding Dang Dong Colors
//
//  Created by Toni on 12/5/24.
//

import SwiftUI

struct ContentView: View {
    @State private var gameStats = GameStats()
    @State private var showGameOverOverlay = true
    @State private var showStartScreenOverlay = true
    
    var body: some View {
        ZStack {
            GameView(
                gameStats: $gameStats)
                .opacity(showGameOverOverlay ? 0.0 : 1.0)
                .animation(.easeInOut(duration: 1.0), value: showGameOverOverlay)

            if showGameOverOverlay {
                if showStartScreenOverlay {
                    StartScreenView() {
                        showStartScreenOverlay = false
                        RestartGame()
                    }
                } else {
                    GameOverView() {
                        RestartGame()
                    }
                }
            }
        }
        .onChange(of: gameStats.gameOver, initial: true) {
            if gameStats.gameOver {
                withAnimation {
                    showGameOverOverlay = true
                }
            }
        }
    }
    
    func RestartGame() {
        print("!")
        gameStats.resetGame()
        showGameOverOverlay = false
    }
}

#Preview {
    //ContentView
}
