import SwiftUI

struct GameOverView: View {
    @State private var showGameOverContent = false
    @State private var backgroundOpacity = 0.0
    
    var body: some View {
        ZStack {
            // Darkening background
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0), .black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .opacity(backgroundOpacity)
            .edgesIgnoringSafeArea(.all)
            .animation(.easeInOut(duration: 1.0), value: backgroundOpacity)
            
            if showGameOverContent {
                mainGameOverContent
            } else {
                GameOverAnimationView {
                    withAnimation {
                        showGameOverContent = true
                        backgroundOpacity = 1.0
                    }
                }
            }
        }
    }
    
    var mainGameOverContent: some View {
        VStack {
            Text("Game Over")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    GameOverView()
}
