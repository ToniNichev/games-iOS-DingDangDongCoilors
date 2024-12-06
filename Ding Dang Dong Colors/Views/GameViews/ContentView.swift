//
//  ContentView.swift
//  Ding Dang Dong Colors
//
//  Created by Toni on 12/5/24.
//

import SwiftUI

struct ContentView: View {
    @State private var gameStats = GameStats()
    
    var body: some View {
        if gameStats.gameOver {
            GameOverView()
        } else {
            GameView(gameStats: $gameStats)
        }
    }
}

#Preview {
    ContentView()
}
