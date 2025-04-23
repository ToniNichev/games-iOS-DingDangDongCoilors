import SwiftUI

struct FallingClock: Identifiable {
    let id = UUID()
    var x: Double
    var y: Double
    var size: CGFloat
    var isActive: Bool = true
    var timeBonus: Int = 5 // Default time bonus
}

struct FallingClockView: View {
    @Binding var gameLevel: Int
    @State private var clock: FallingClock?
    @State private var animationTimer: Timer?
    @State private var animatingScale: Bool = false
    @State private var animatingRotation: Bool = false
    
    // Callback when clock is tapped
    var onClockTapped: (Int) -> Void
    
    // Configurable properties
    let clockSize: CGFloat = 55
    let clockColor: Color = .blue
    
    // Calculate drop speed based on game level
    var dropSpeed: Double {
        return max(2.5, 6.5 - Double(gameLevel) * 0.2) // Faster drops at higher levels
    }
    
    // Calculate spawn frequency based on game level
    var spawnFrequency: Double {
        return max(8.0, 25.0 - Double(gameLevel) * 0.7) // Less frequent than hearts
    }
    
    // Calculate chance of clock appearing (lower levels have higher chance)
    var clockAppearChance: Double {
        return max(0.25, 0.8 - Double(gameLevel) * 0.04) // Between 25% and 80% chance
    }
    
    // Calculate time bonus based on level (less bonus at higher levels)
    var timeBonus: Int {
        return max(3, 8 - min(5, gameLevel)) // Between 3 and 8 seconds
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let clock = clock, clock.isActive {
                    ZStack {
                        // Glowing background effect
                        Circle()
                            .fill(Color.cyan.opacity(0.2))
                            .frame(width: clock.size * 1.6, height: clock.size * 1.6)
                            .blur(radius: 6)
                            .position(x: clock.x, y: clock.y)
                        
                        // Clock with animations
                        ZStack {
                            // Clock face
                            Circle()
                                .fill(Color.white.opacity(0.8))
                                .frame(width: clock.size, height: clock.size)
                                .shadow(color: .blue.opacity(0.6), radius: 8)
                            
                            // Clock face details
                            Circle()
                                .stroke(Color.blue, lineWidth: 3)
                                .frame(width: clock.size - 4, height: clock.size - 4)
                            
                            // Clock hands
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 2, height: clock.size * 0.35)
                                .offset(y: -clock.size * 0.1)
                                .rotationEffect(.degrees(animatingRotation ? 360 : 0))
                            
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 2, height: clock.size * 0.25)
                                .offset(y: -clock.size * 0.05)
                                .rotationEffect(.degrees(animatingRotation ? 720 : 0))
                            
                            // Display time bonus
                            Text("+\(clock.timeBonus)s")
                                .font(.system(size: clock.size * 0.3, weight: .bold))
                                .foregroundColor(.blue)
                                .offset(y: clock.size * 0.15)
                        }
                        .frame(width: clock.size, height: clock.size)
                        .position(x: clock.x, y: clock.y)
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
                        if let clock = self.clock, clock.isActive {
                            // Trigger clock collected animation
                            withAnimation(.spring()) {
                                self.clock?.isActive = false
                            }
                            
                            // Call the callback with time bonus
                            onClockTapped(clock.timeBonus)
                            
                            // Schedule the next clock after a delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                scheduleNextClock(bounds: geometry.size)
                            }
                        }
                    }
                }
            }
            .onAppear {
                // Initial scheduling with a random delay
                DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 5.0...10.0)) {
                    scheduleNextClock(bounds: geometry.size)
                }
            }
            .onDisappear {
                // Clean up timer when view disappears
                animationTimer?.invalidate()
                animationTimer = nil
            }
        }
    }
    
    private func scheduleNextClock(bounds: CGSize) {
        // Cancel any existing timer
        animationTimer?.invalidate()
        
        // Determine if a clock should appear based on chance
        let shouldAppear = Double.random(in: 0...1) < clockAppearChance
        
        if shouldAppear {
            // Create a new clock at the top of the screen with random X position
            let x = Double.random(in: clockSize...(bounds.width - clockSize))
            clock = FallingClock(
                x: x,
                y: clockSize/2,
                size: clockSize,
                timeBonus: timeBonus
            )
            
            // Start the animation timer
            animationTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                guard var currentClock = clock, currentClock.isActive else {
                    timer.invalidate()
                    return
                }
                
                // Move the clock down
                currentClock.y += dropSpeed
                clock = currentClock
                
                // Check if clock has gone off screen
                if currentClock.y > bounds.height + clockSize {
                    // Clock missed, make it inactive
                    clock?.isActive = false
                    timer.invalidate()
                    
                    // Schedule the next clock after a delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + spawnFrequency) {
                        scheduleNextClock(bounds: bounds)
                    }
                }
            }
        } else {
            // No clock this time, schedule next check
            DispatchQueue.main.asyncAfter(deadline: .now() + spawnFrequency) {
                scheduleNextClock(bounds: bounds)
            }
        }
    }
}

#Preview {
    FallingClockView(gameLevel: .constant(1)) { timeBonus in
        print("Clock tapped! +\(timeBonus) seconds")
    }
}
