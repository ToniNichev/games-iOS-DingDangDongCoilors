import SwiftUI

struct HeartParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var scale: CGFloat
    var rotation: Double
    var opacity: Double
    var color: Color
}

struct HeartParticleView: View {
    var position: CGPoint
    @State private var particles: [HeartParticle] = []
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Image(systemName: "heart.fill")
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
        particles = []
        for _ in 0..<12 {
            let randomOffset = CGPoint(
                x: CGFloat.random(in: -50...50),
                y: CGFloat.random(in: -50...50)
            )
            
            let particle = HeartParticle(
                position: CGPoint(
                    x: position.x + randomOffset.x,
                    y: position.y + randomOffset.y
                ),
                scale: CGFloat.random(in: 0.2...0.5),
                rotation: Double.random(in: 0...360),
                opacity: 1.0,
                color: [.red, .pink, .orange, .purple].randomElement()!
            )
            
            particles.append(particle)
        }
    }
    
    private func animateParticles() {
        isAnimating = true
        
        withAnimation(.easeOut(duration: 1.2)) {
            for i in 0..<particles.count {
                let randomDirection = CGPoint(
                    x: CGFloat.random(in: -100...100),
                    y: CGFloat.random(in: -100...100)
                )
                
                particles[i].position = CGPoint(
                    x: particles[i].position.x + randomDirection.x,
                    y: particles[i].position.y + randomDirection.y
                )
                
                particles[i].scale *= CGFloat.random(in: 1.2...2.0)
                particles[i].rotation += Double.random(in: 180...720)
                particles[i].opacity = 0
            }
        }
    }
}

#Preview {
    HeartParticleView(position: CGPoint(x: 200, y: 300))
}
