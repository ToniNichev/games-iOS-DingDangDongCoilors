import SwiftUI

struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var opacity: Double
    var color: Color
    let angle: CGFloat
    let speed: CGFloat
}

struct ParticleEmitterView: View {
    @State private var particles: [Particle] = []
    @State var animationDuraton: TimeInterval = 0.009
    var posX = UIScreen.main.bounds.width / 2
    var posY = UIScreen.main.bounds.height / 2
    var fixedCircleColor: Color?
    var onExplosionEnded: (() -> Void) = { }
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(x: particle.x, y: particle.y)
                    .opacity(particle.opacity)
            }
        }
        .onAppear {
            createExplosion(x: posX, y: posY)
        }
    }
    
    func createExplosion(x: CGFloat, y: CGFloat) {
        let colors: [Color] = [.red, .orange, .yellow, .white]
        let particleCount = 100

        for _ in 0..<particleCount {
            let angle = CGFloat.random(in: 0...360) * .pi / 180 // Convert to radians
            let speed = CGFloat.random(in: 100...300)
            let size = CGFloat.random(in: 5...15)
            let color = fixedCircleColor ?? colors.randomElement()!
            let opacity = Double.random(in: 0.7...1.0)

            let particle = Particle(
                x: x,
                y: y,
                size: size,
                opacity: opacity,
                color: color,
                angle: angle,
                speed: speed
            )
            particles.append(particle)
        }

        // Animate particles
        Timer.scheduledTimer(withTimeInterval: animationDuraton, repeats: true) { timer in
            var allParticlesFaded = true

            for index in particles.indices {
                let particle = particles[index]

                // Update particle position
                particles[index].x += cos(particle.angle) * particle.speed * animationDuraton
                particles[index].y += sin(particle.angle) * particle.speed * animationDuraton

                // Reduce opacity
                particles[index].opacity -= 0.02
                if particles[index].opacity > 0 {
                    allParticlesFaded = false
                }
            }

            // Stop the timer and clear particles when done
            if allParticlesFaded {
                timer.invalidate()
                particles.removeAll()
                onExplosionEnded()
            }
        }
    }
}
