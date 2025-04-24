import SwiftUI

struct SpeedPotionParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var scale: CGFloat
    var rotation: Double
    var opacity: Double
    var color: Color
    var symbol: String // Different symbols for variety
}

struct SpeedPotionParticleView: View {
    var position: CGPoint
    @State private var particles: [SpeedPotionParticle] = []
    @State private var numberParticles: [SpeedPotionParticle] = []
    @State private var isAnimating = false
    
    // Symbols to use for particles
    let symbols = ["arrow.counterclockwise", "arrow.clockwise", "clock", "timer", "arrow.down.circle.fill"]
    
    var body: some View {
        ZStack {
            // Symbol particles
            ForEach(particles) { particle in
                Image(systemName: particle.symbol)
                    .foregroundColor(particle.color)
                    .scaleEffect(particle.scale)
                    .rotationEffect(.degrees(particle.rotation))
                    .opacity(particle.opacity)
                    .position(particle.position)
            }
            
            // Number particles (showing the speed reset text)
            ForEach(numberParticles) { particle in
                Text("Level 1 Speed")
                    .font(.system(size: 14 * particle.scale, weight: .bold))
                    .foregroundColor(particle.color)
                    .scaleEffect(particle.scale)
                    .rotationEffect(.degrees(particle.rotation))
                    .opacity(particle.opacity)
                    .position(particle.position)
            }
        }
        .onAppear {
            createParticles()
            animateParticles()
        }
    }
    
    private func createParticles() {
        // Create symbol particles
        particles = []
        for _ in 0..<10 {
            let randomOffset = CGPoint(
                x: CGFloat.random(in: -60...60),
                y: CGFloat.random(in: -60...60)
            )
            
            let particle = SpeedPotionParticle(
                position: CGPoint(
                    x: position.x + randomOffset.x,
                    y: position.y + randomOffset.y
                ),
                scale: CGFloat.random(in: 0.3...0.6),
                rotation: Double.random(in: 0...360),
                opacity: 1.0,
                color: [.purple, .indigo, .purple, .blue].randomElement()!,
                symbol: symbols.randomElement()!
            )
            
            particles.append(particle)
        }
        
        // Create number particles
        numberParticles = []
        for _ in 0..<5 {
            let randomOffset = CGPoint(
                x: CGFloat.random(in: -40...40),
                y: CGFloat.random(in: -40...40)
            )
            
            let particle = SpeedPotionParticle(
                position: CGPoint(
                    x: position.x + randomOffset.x,
                    y: position.y + randomOffset.y
                ),
                scale: CGFloat.random(in: 0.8...1.2),
                rotation: Double.random(in: -15...15),
                opacity: 1.0,
                color: [.purple, .indigo, .white].randomElement()!,
                symbol: ""  // Not used for number particles
            )
            
            numberParticles.append(particle)
        }
    }
    
    private func animateParticles() {
        isAnimating = true
        
        // Animate symbol particles
        withAnimation(.easeOut(duration: 1.5)) {
            for i in 0..<particles.count {
                let randomDirection = CGPoint(
                    x: CGFloat.random(in: -120...120),
                    y: CGFloat.random(in: -120...120)
                )
                
                particles[i].position = CGPoint(
                    x: particles[i].position.x + randomDirection.x,
                    y: particles[i].position.y + randomDirection.y
                )
                
                particles[i].scale *= CGFloat.random(in: 1.2...1.8)
                particles[i].rotation += Double.random(in: 180...720)
                particles[i].opacity = 0
            }
        }
        
        // Animate number particles (rising up animation)
        withAnimation(.easeOut(duration: 1.8)) {
            for i in 0..<numberParticles.count {
                numberParticles[i].position = CGPoint(
                    x: numberParticles[i].position.x,
                    y: numberParticles[i].position.y - CGFloat.random(in: 80...120)
                )
                
                numberParticles[i].scale *= 1.3
                numberParticles[i].opacity = 0
            }
        }
    }
}

#Preview {
    SpeedPotionParticleView(position: CGPoint(x: 200, y: 300))
}
