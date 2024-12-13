import SwiftUI

struct GameOverView: View {
    @State private var showGameOverContent = false
    @State private var backgroundOpacity = 0.8
    var gameStats: GameStats
    //let RestartGameAction: () -> Void
    
    let AppStateChange: (_ newAppState: AppState) -> Void
    
    var body: some View {
        ZStack {
            // Full-screen dark overlay with animated opacity
            Color.black
                .opacity(backgroundOpacity)
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut(duration: 1.0), value: backgroundOpacity)
            
            // "Game Over" text that appears after the background fades in
            if showGameOverContent {
                GameOverContentView(gameStats: gameStats) {newAppState in 
                    //RestartGameAction()
                    AppStateChange(newAppState)
                }
            }
        }
        .onAppear {
            // After a delay, show the "Game Over" text
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    showGameOverContent = true
                }
            }
        }
    }
}

#Preview {
    
    @Previewable @State var gameStats = GameStats()
    
    GameOverView(gameStats:gameStats) {newAppState in 
        print("Restarting game ...")
    }
    
}
