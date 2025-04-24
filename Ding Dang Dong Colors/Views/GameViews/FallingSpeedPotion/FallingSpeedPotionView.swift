import SwiftUI

struct FallingSpeedPotion: Identifiable {
    let id = UUID()
    var x: Double
    var y: Double
    var size: CGFloat
    var isActive: Bool = true
}

struct FallingSpeedPotionView: View {
    @Binding var gameLevel: Int
    @State private var potion: FallingSpeedPotion?
    @State private var animationTimer: Timer?
    @State private var animatingScale: Bool = false
    @State private var animatingRotation: Bool = false
    
    // Callback when potion is tapped
    var onPotionTapped: () -> Void
    
    // Configurable properties
    let potionSize: CGFloat = 58
    let potionColor: Color = .purple
    
    // Calculate drop speed based on game level
    var dropSpeed: Double {
        return max(2.0, 6.0 - Double(gameLevel) * 0.15) // Slightly slower than other power-ups
    }
    
    // Calculate spawn frequency based on game level
    var spawnFrequency: Double {
        // return max(10.0, 30.0 - Double(gameLevel) * 0.7) // Less frequent than other power-ups
        return max(6.0, 18.0 - Double(gameLevel) * 0.6) // More frequent spawns
    }
    
    // Calculate chance of potion appearing (rarer at higher levels when needed most)
    var potionAppearChance: Double {
        return max(0.2, 0.7 - Double(gameLevel) * 0.03) // Between 20% and 70% chance
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let potion = potion, potion.isActive {
                    ZStack {
                        // Glowing background effect
                        Circle()
                            .fill(Color.purple.opacity(0.2))
                            .frame(width: potion.size * 1.7, height: potion.size * 1.7)
                            .blur(radius: 6)
                            .position(x: potion.x, y: potion.y)
                        
                        // Potion with animations
                        ZStack {
                            // Potion bottle
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: potion.size * 0.8, height: potion.size * 0.8)
                                .foregroundColor(potionColor)
                                .shadow(color: .purple.opacity(0.5), radius: 5)
                                .overlay(
                                    // Speed indicator
                                    Text("Speed")
                                        .font(.system(size: potion.size * 0.2, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .background(Color.black.opacity(0.6))
                                        .cornerRadius(8)
                                        .offset(y: potion.size * 0.5)
                                )
                            
                            // Sparkle effects
                            ForEach(0..<5) { i in
                                Image(systemName: "sparkle")
                                    .font(.system(size: potion.size * 0.15))
                                    .foregroundColor(.white)
                                    .offset(
                                        x: potion.size * 0.3 * cos(Double(i) * 0.4 + (animatingRotation ? 2 : 0)),
                                        y: potion.size * 0.3 * sin(Double(i) * 0.4 + (animatingRotation ? 2 : 0))
                                    )
                                    .opacity(0.8)
                            }
                            
                        }
                        .frame(width: potion.size, height: potion.size)
                        .position(x: potion.x, y: potion.y)
                        .scaleEffect(animatingScale ? 1.1 : 0.95)
                        .animation(
                            Animation.easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true),
                            value: animatingScale
                        )
                    }
                    .onAppear {
                        animatingScale = true
                        animatingRotation = true
                    }
                    .onTapGesture {
                        if let potion = self.potion, potion.isActive {
                            // Trigger potion collected animation
                            withAnimation(.spring()) {
                                self.potion?.isActive = false
                            }
                            
                            // Call the callback
                            onPotionTapped()
                            
                            // Schedule the next potion after a delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                scheduleNextPotion(bounds: geometry.size)
                            }
                        }
                    }
                }
            }
            .onAppear {
                // Initial scheduling with a random delay
                DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 8.0...15.0)) {
                    scheduleNextPotion(bounds: geometry.size)
                }
            }
            .onDisappear {
                // Clean up timer when view disappears
                animationTimer?.invalidate()
                animationTimer = nil
            }
        }
    }
    
    private func scheduleNextPotion(bounds: CGSize) {
        // Cancel any existing timer
        animationTimer?.invalidate()
        
        // Determine if a potion should appear based on chance
        let shouldAppear = Double.random(in: 0...1) < potionAppearChance
        
        if shouldAppear {
            // Create a new potion at the top of the screen with random X position
            let x = Double.random(in: potionSize...(bounds.width - potionSize))
            potion = FallingSpeedPotion(
                x: x,
                y: potionSize/2,
                size: potionSize
            )
            
            // Start the animation timer
            animationTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                guard var currentPotion = potion, currentPotion.isActive else {
                    timer.invalidate()
                    return
                }
                
                // Move the potion down
                currentPotion.y += dropSpeed
                potion = currentPotion
                
                // Check if potion has gone off screen
                if currentPotion.y > bounds.height + potionSize {
                    // Potion missed, make it inactive
                    potion?.isActive = false
                    timer.invalidate()
                    
                    // Schedule the next potion after a delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + spawnFrequency) {
                        scheduleNextPotion(bounds: bounds)
                    }
                }
            }
        } else {
            // No potion this time, schedule next check
            DispatchQueue.main.asyncAfter(deadline: .now() + spawnFrequency) {
                scheduleNextPotion(bounds: bounds)
            }
        }
    }
}

#Preview {
    FallingSpeedPotionView(gameLevel: .constant(3)) {
        print("Potion tapped! Speed reset to level 1")
    }
}
