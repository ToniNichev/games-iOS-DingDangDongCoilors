//
//  ContentView.swift
//  Ding Dang Dong Colors
//
//  Created by Toni on 12/5/24.
//

import SwiftUI
import GameKit

enum AppState {
    case startScreen
    case gameView
    case gameOver
}

struct ContentView: View {
    // Use StateObject instead of State for reference types
    @StateObject private var gameStats = GameStats()
    @State private var showGameOverOverlay = true
    @State private var showStartScreenOverlay = true
    
    var body: some View {
        ZStack {
            // Use ObservedObject binding for GameView
            GameView(gameStats: gameStats)
                .opacity(showGameOverOverlay ? 0.0 : 1.0)
                .animation(.easeInOut(duration: 1.0), value: showGameOverOverlay)

            if showGameOverOverlay {
                if showStartScreenOverlay {
                    StartScreenView() {
                        showStartScreenOverlay = false
                        RestartGame()
                    }
                } else {
                    GameOverView(gameStats: gameStats) { newAppState in
                        AppStateChange(newState: newAppState)
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
        .sheet(isPresented: $gameStats.showLeaderboard) {
            GameCenterView()
        }
        .onAppear {
            gameStats.authenticateGameCenter()
        }
    }
    
    func AppStateChange(newState: AppState) {
        switch newState {
        case .startScreen:
            showStartScreenOverlay = true
            gameStats.stopTimer()
        case .gameView:
            RestartGame()
        case .gameOver:
            showGameOverOverlay = true
            gameStats.stopTimer()
        }
    }
    
    func RestartGame() {
        gameStats.resetGame()
        showGameOverOverlay = false
    }
}

#Preview {
    ContentView()
}
