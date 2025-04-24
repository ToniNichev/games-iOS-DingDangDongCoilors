import SwiftUI
import GameKit

struct GameOverView: View {
    @ObservedObject var gameStats: GameStats
    let onAppStateChange: (AppState) -> Void
    
    // Animation states
    @State private var animateTitle = false
    @State private var animateScore = false
    @State private var animateStats = false
    @State private var animateButtons = false
    @State private var pulsateScore = false
    
    // Flag to detect when the view appears after ad
    @State private var isViewReady = false
    @State private var animationsTriggered = false
    
    // Particles for visual effect
    @State private var particles: [GameOverParticle] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [.black, .red.opacity(0.8)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                // Particle effects
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                        .opacity(particle.opacity)
                }
                
                VStack(spacing: 0) {
                    // Game Over Title with animation
                    Text("GAME OVER")
                        .font(.system(size: min(geometry.size.width * 0.15, 60), weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .red, radius: 10, x: 0, y: 0)
                        .padding(.top, geometry.size.height * 0.05)
                        .padding(.bottom, geometry.size.height * 0.02)
                        .offset(y: animateTitle ? 0 : -200)
                        .opacity(animateTitle ? 1 : 0)
                    
                    // Final Score with animation
                    VStack(spacing: 10) {
                        Text("Final Score")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Text("\(gameStats.score)")
                            .font(.system(size: min(geometry.size.width * 0.2, 80), weight: .bold))
                            .foregroundColor(.yellow)
                            .shadow(color: .orange, radius: 5)
                            .scaleEffect(pulsateScore ? 1.1 : 1.0)
                    }
                    .padding(15)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.black.opacity(0.7), .red.opacity(0.3)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.orange.opacity(0.7), .yellow.opacity(0.3)]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .shadow(color: .red.opacity(0.5), radius: 10)
                    )
                    .padding(.horizontal)
                    .offset(y: animateScore ? 0 : 100)
                    .opacity(animateScore ? 1 : 0)
                    .padding(.bottom, geometry.size.height * 0.03)
                    
                    // Game Stats with animation
                    VStack(spacing: 20) {
                        statRow(title: "Level Reached", value: "\(gameStats.level)", icon: "arrow.up.circle.fill")
                        
                        Divider()
                            .background(Color.gray.opacity(0.5))
                            .padding(.horizontal)
                        
                        statRow(title: "Time Ran Out", value: gameStats.timeRemaining <= 0 ? "Yes" : "No", icon: "timer")
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.black.opacity(0.5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal)
                    .offset(y: animateStats ? 0 : 100)
                    .opacity(animateStats ? 1 : 0)
                    .padding(.bottom, geometry.size.height * 0.03)
                    
                    // Flexible spacer to push content up
                    Spacer(minLength: 0)
                    
                    // Buttons with animation - now using a more compact layout
                    VStack(spacing: 15) {
                        // Game Center Button (if authenticated)
                        if gameStats.gameCenterEnabled {
                            Button(action: {
                                gameStats.showGameCenter()
                            }) {
                                HStack {
                                    Image(systemName: "trophy.fill")
                                        .font(.system(size: 16))
                                    Text("Leaderboard")
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.blue.opacity(0.8), .purple.opacity(0.8)]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .shadow(color: .black.opacity(0.3), radius: 5)
                                )
                            }
                            .padding(.bottom, 5)
                            .offset(y: animateButtons ? 0 : 50)
                            .opacity(animateButtons ? 1 : 0)
                        }
                        
                        // Play Again and Main Menu buttons side by side
                        HStack(spacing: 15) {
                            // Play Again button
                            Button(action: {
                                withAnimation {
                                    onAppStateChange(.gameView)
                                }
                            }) {
                                VStack {
                                    Image(systemName: "arrow.counterclockwise.circle.fill")
                                        .font(.system(size: 20))
                                        .padding(.bottom, 2)
                                    Text("Play Again")
                                        .font(.system(size: 14, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(width: 110, height: 70)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.green.opacity(0.8), .green.opacity(0.5)]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .shadow(color: .black.opacity(0.3), radius: 5)
                                )
                            }
                            
                            // Main Menu button
                            Button(action: {
                                withAnimation {
                                    onAppStateChange(.startScreen)
                                }
                            }) {
                                VStack {
                                    Image(systemName: "house.fill")
                                        .font(.system(size: 20))
                                        .padding(.bottom, 2)
                                    Text("Main Menu")
                                        .font(.system(size: 14, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(width: 110, height: 70)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.blue.opacity(0.8), .blue.opacity(0.5)]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .shadow(color: .black.opacity(0.3), radius: 5)
                                )
                            }
                        }
                        .offset(y: animateButtons ? 0 : 50)
                        .opacity(animateButtons ? 1 : 0)
                    }
                    .padding(.bottom, 15)
                    
                    // Banner Ad - ensuring it's visible
                    BannerAd(adUnitID: AdConfig.GameOverBannerAdUnitId)
                        .frame(height: 50)
                        .opacity(animateButtons ? 1 : 0)
                        .padding(.bottom, 5) // Small padding at the bottom to ensure visibility
                }
                .padding(.horizontal)
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .onAppear {
            gameStats.stopTimer()
            
            // Submit score to Game Center when game over screen appears
            if gameStats.gameCenterEnabled {
                gameStats.submitScoreToGameCenter()
            }
            
            // Generate particles for visual effect
            generateParticles()
            
            // Mark the view as ready, but don't trigger animations yet
            isViewReady = true
            
            // Schedule a check to see if we should start animations
            checkAndTriggerAnimations()
        }
        // This will detect when the view becomes visible to the user
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            if isViewReady && !animationsTriggered {
                // This will trigger when the app becomes active after showing an ad
                startAnimations()
            }
        }
    }
    
    // Helper function to check if we should start animations
    private func checkAndTriggerAnimations() {
        // Wait a short delay to allow any ad to be shown
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if isViewReady && !animationsTriggered {
                startAnimations()
            }
        }
    }
    
    private func statRow(title: String, value: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.red)
                .frame(width: 25)
            
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
    
    // Start all animations with staggered timing
    private func startAnimations() {
        // Mark animations as triggered so we don't repeat them
        animationsTriggered = true
        
        // Title animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
            animateTitle = true
        }
        
        // Score animation with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
                animateScore = true
            }
            
            // Start score pulsing animation
            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulsateScore = true
            }
        }
        
        // Stats animation with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
                animateStats = true
            }
        }
        
        // Buttons animation with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
                animateButtons = true
            }
        }
    }
    
    // Generate particles for visual effect
    private func generateParticles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        // Create particles
        var newParticles: [GameOverParticle] = []
        
        for _ in 0..<20 {
            let particle = GameOverParticle(
                id: UUID(),
                position: CGPoint(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: CGFloat.random(in: 0...screenHeight)
                ),
                size: CGFloat.random(in: 3...7),
                opacity: Double.random(in: 0.1...0.4),
                color: [.red, .orange, .yellow].randomElement()!
            )
            newParticles.append(particle)
        }
        
        // Add particles
        particles = newParticles
        
        // Animate particles
        for i in 0..<particles.count {
            withAnimation(
                Animation.easeInOut(duration: Double.random(in: 5...10))
                    .repeatForever(autoreverses: true)
            ) {
                particles[i].position = CGPoint(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: CGFloat.random(in: 0...screenHeight)
                )
                particles[i].opacity = Double.random(in: 0.1...0.4)
            }
        }
    }
}

// Particle structure for Game Over screen
struct GameOverParticle: Identifiable {
    let id: UUID
    var position: CGPoint
    var size: CGFloat
    var opacity: Double
    var color: Color
}

#Preview {
    @Previewable let previewGameStats = GameStats()
    GameOverView(gameStats: previewGameStats) { _ in }
}
