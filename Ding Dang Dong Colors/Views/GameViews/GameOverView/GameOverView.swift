import SwiftUI
import GameKit

struct GameOverView: View {
    @ObservedObject var gameStats: GameStats
    let onAppStateChange: (AppState) -> Void
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [.black, .red.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Game Over Title
                Text("GAME OVER")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .red, radius: 10, x: 0, y: 0)
                    .padding(.top, 50)
                
                // Final Score
                VStack(spacing: 15) {
                    Text("Final Score")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Text("\(gameStats.score)")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.yellow)
                        .shadow(color: .orange, radius: 5)
                }
                
                // Game Stats
                VStack(spacing: 25) {
                    statRow(title: "Level Reached", value: "\(gameStats.level)")
                    statRow(title: "Time Ran Out", value: gameStats.timeRemaining <= 0 ? "Yes" : "No")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.black.opacity(0.5))
                )
                .padding(.horizontal)
                
                Spacer()
                
                // Game Center Button (if authenticated)
                if gameStats.gameCenterEnabled {
                    CustomButton(label: "Leaderboard", action: {
                        // Properly access the property through the wrapper
                        gameStats.showGameCenter()
                    })
                    .padding(.bottom, 20)
                }
                
                // Buttons
                HStack(spacing: 30) {
                    // Play Again button
                    CustomButton(label: "Play Again", action: {
                        onAppStateChange(.gameView)
                    })
                    
                    // Main Menu button
                    CustomButton(label: "Main Menu", action: {
                        onAppStateChange(.startScreen)
                    })
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            gameStats.stopTimer()
            
            // Submit score to Game Center when game over screen appears
            if gameStats.gameCenterEnabled {
                gameStats.submitScoreToGameCenter()
            }
        }
    }
    
    private func statRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.orange)
        }
        .padding(.horizontal)
    }
}

#Preview {
    @Previewable let previewGameStats = GameStats()
    GameOverView(gameStats: previewGameStats) { _ in }
}
