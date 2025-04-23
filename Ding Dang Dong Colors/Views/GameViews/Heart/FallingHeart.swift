import SwiftUI

struct FallingHeart: Identifiable {
    let id = UUID()
    var x: Double
    var y: Double
    var size: CGFloat
    var isActive: Bool = true
}

struct FallingHeartView: View {
    @Binding var gameLevel: Int
    @State private var heart: FallingHeart?
    @State private var animationTimer: Timer?
    @State private var animatingScale: Bool = false
    
    // Callback when heart is tapped
    var onHeartTapped: () -> Void
    
    // Configurable properties
    let heartSize: CGFloat = 60
    let heartColor: Color = .red
    
    // Calculate drop speed based on game level
    var dropSpeed: Double {
        return max(2.0, 6.0 - Double(gameLevel) * 0.2) // Faster drops at higher levels
    }
    
    // Calculate spawn frequency based on game level
    var spawnFrequency: Double {
        return max(5.0, 20.0 - Double(gameLevel) * 0.8) // More frequent at higher levels, but not too frequent
    }
    
    // Calculate chance of heart appearing (lower levels have higher chance)
    var heartAppearChance: Double {
        return max(0.3, 1.0 - Double(gameLevel) * 0.05) // Between 30% and 100% chance
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let heart = heart, heart.isActive {
                    ZStack {
                        // Glowing background effect
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: heart.size * 1.5, height: heart.size * 1.5)
                            .blur(radius: 5)
                            .position(x: heart.x, y: heart.y)
                        
                        // Heart with pulsating animation
                        Image(systemName: "heart.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: heart.size, height: heart.size)
                            .foregroundColor(heartColor)
                            .shadow(color: .white, radius: 10)
                            .overlay(
                                Image(systemName: "sparkles")
                                    .font(.system(size: heart.size * 0.8))
                                    .foregroundColor(.yellow)
                                    .opacity(0.8)
                            )
                            .position(x: heart.x, y: heart.y)
                            .scaleEffect(animatingScale ? 1.1 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 0.7)
                                    .repeatForever(autoreverses: true),
                                value: animatingScale
                            )
                            .onAppear {
                                animatingScale = true
                            }
                    }
                    .onTapGesture {
                        if let heart = self.heart, heart.isActive {
                            // Trigger heart collected animation
                            withAnimation(.spring()) {
                                self.heart?.isActive = false
                            }
                            
                            // Call the callback
                            onHeartTapped()
                            
                            // Schedule the next heart after a delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                scheduleNextHeart(bounds: geometry.size)
                            }
                        }
                    }
                }
            }
            .onAppear {
                // Initial scheduling with a random delay
                DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 3.0...8.0)) {
                    scheduleNextHeart(bounds: geometry.size)
                }
            }
            .onDisappear {
                // Clean up timer when view disappears
                animationTimer?.invalidate()
                animationTimer = nil
            }
        }
    }
    
    private func scheduleNextHeart(bounds: CGSize) {
        // Cancel any existing timer
        animationTimer?.invalidate()
        
        // Determine if a heart should appear based on chance
        let shouldAppear = Double.random(in: 0...1) < heartAppearChance
        
        if shouldAppear {
            // Create a new heart at the top of the screen with random X position
            let x = Double.random(in: heartSize...(bounds.width - heartSize))
            heart = FallingHeart(x: x, y: heartSize/2, size: heartSize)
            
            // Start the animation timer
            animationTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                guard var currentHeart = heart, currentHeart.isActive else {
                    timer.invalidate()
                    return
                }
                
                // Move the heart down
                currentHeart.y += dropSpeed
                heart = currentHeart
                
                // Check if heart has gone off screen
                if currentHeart.y > bounds.height + heartSize {
                    // Heart missed, make it inactive
                    heart?.isActive = false
                    timer.invalidate()
                    
                    // Schedule the next heart after a delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + spawnFrequency) {
                        scheduleNextHeart(bounds: bounds)
                    }
                }
            }
        } else {
            // No heart this time, schedule next check
            DispatchQueue.main.asyncAfter(deadline: .now() + spawnFrequency) {
                scheduleNextHeart(bounds: bounds)
            }
        }
    }
}

#Preview {
    FallingHeartView(gameLevel: .constant(1)) {
        print("Heart tapped!")
    }
}
