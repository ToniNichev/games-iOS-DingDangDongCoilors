import SwiftUI



struct MovingCircle: Identifiable {
    let id: UUID
    var x: Double = 0
    var y: Double = 0
    var radius: Double = 100
    var color: Color = .red
    var points: Int = 10
}


struct MovingCirclesView: View {
    let colors: [Color] = [.red, .blue, .green, .yellow]
    @State var movingCircles: [MovingCircle] = []
    @State var movementTimer: Timer? = nil
    @State var showExplosion: Bool = false
    @State var x: CGFloat = 0
    @State var y: CGFloat = 0
    
    var circlesCount: Int
    var movementInterval: Double
    var minRadius = 10.0
    var maxRadius = 120.0
    var animationType: Animation = .linear(duration: 4)
    var removeCircleOnTapped: Bool = true
    var fixedCircleColor: Color?
    @State var tappedCircleColor: Color?
    
    var onCircleTapped: ((MovingCircle) -> Void)
    var allCirclesCleared: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(movingCircles) { circle in
                    Circle()
                        .fill(circle.color)
                        .frame(width: circle.radius, height: circle.radius)
                        .position(x: circle.x, y: circle.y)
                        .transition(.scale(scale: 0.5, anchor: .center).combined(with: .opacity))
                        .onTapGesture { location in
                            x = location.x
                            y = location.y
                            showExplosion = true
                            tappedCircleColor = circle.color
                            
                            onCircleTapped(circle)
                            if removeCircleOnTapped {
                                removeCircle(withId: circle.id, bounds: geometry.size)
                            }
                        }
                }
                
                if showExplosion {
                    ParticleEmitterView(
                        posX: x,
                        posY: y,
                        fixedCircleColor: tappedCircleColor) {
                            //on explosion ended, hide the particles
                            showExplosion = false
                    }
                }
            }
            .onAppear {
                generateInitialCircles(bounds: geometry.size)
            }
            .onChange(of: circlesCount, initial: true, {
                updateCircleCount(to: circlesCount, bounds: geometry.size)
            })
            .onChange(of: movementInterval, initial: true) {
                adjustSpeed(to: movementInterval)
            }
            .onDisappear {
                movementTimer?.invalidate()
            }
        }
    }
    
    private func adjustSpeed(to newInterval: Double) {
        movementTimer?.invalidate()
        movementTimer = Timer.scheduledTimer(withTimeInterval: newInterval, repeats: true) { _ in
            withAnimation(animationType) {
                movingCircles = movingCircles.map { circle in
                    var newCircle = circle
                    newCircle.x = Double.random(in: maxRadius...(UIScreen.main.bounds.width - maxRadius))
                    newCircle.y = Double.random(in: maxRadius...(UIScreen.main.bounds.height - maxRadius))
                    return newCircle
                }
            }
        }
    }
    
    private func restartMovement(bounds: CGSize, with interval: Double) {
        movementTimer?.invalidate()
        startRandomMovement(bounds: bounds)
    }
    
    private func generateInitialCircles(bounds: CGSize) {
        movingCircles = generateRandomCircles(count: circlesCount, bounds: bounds)
        startRandomMovement(bounds: bounds)
    }
    
    private func updateCircleCount(to newCount: Int, bounds: CGSize) {
        if newCount > movingCircles.count {
            let additionalCircles = generateRandomCircles(
                count: newCount - movingCircles.count,
                bounds: bounds
            )
            withAnimation(animationType) {
                movingCircles.append(contentsOf: additionalCircles)
            }
            // Immediately move newly added circles
            triggerImmediateMovement(bounds: bounds)
        }
    }

    private func removeCircle(withId id: UUID, bounds: CGSize) {
        withAnimation(.easeInOut(duration: 0.5)) {
            movingCircles.removeAll { $0.id == id }
        }
        if movingCircles.isEmpty {
            allCirclesCleared()
            // Regenerate circles with immediate movement
            updateCircleCount(to: circlesCount, bounds: bounds)
        }
    }
    
    private func startRandomMovement(bounds: CGSize) {
        // Move circles to their initial random positions immediately
        withAnimation(animationType) {
            movingCircles = movingCircles.map { circle in
                var updatedCircle = circle
                updatedCircle.x = Double.random(in: maxRadius...(bounds.width - maxRadius))
                updatedCircle.y = Double.random(in: maxRadius...(bounds.height - maxRadius))
                return updatedCircle
            }
        }
        
        // Start the timer for subsequent movements
        movementTimer = Timer.scheduledTimer(withTimeInterval: movementInterval, repeats: true) { _ in
            withAnimation(animationType) {
                movingCircles = movingCircles.map { circle in
                    var updatedCircle = circle
                    updatedCircle.x = Double.random(in: maxRadius...(bounds.width - maxRadius))
                    updatedCircle.y = Double.random(in: maxRadius...(bounds.height - maxRadius))
                    return updatedCircle
                }
            }
        }
    }
    
    
    func generateRandomCircles(count: Int, bounds: CGSize) -> [MovingCircle] {
        var circles: [MovingCircle] = []
        
        for _ in 0..<count {
            var isOverlapping: Bool
            var circle: MovingCircle
            
            repeat {
                isOverlapping = false
                let x = Double.random(in: maxRadius...(bounds.width - maxRadius))
                let y = Double.random(in: maxRadius...(bounds.height - maxRadius))
                let radius = Double.random(in: minRadius...maxRadius)
                let color =  fixedCircleColor ?? colors.randomElement()!
                let points = Int.random(in: 5...10)
                
                circle = MovingCircle(
                    id: UUID(),
                    x: x,
                    y: y,
                    radius: radius,
                    color: color,
                    points: points)
                
                for existingCircle in circles {
                    let dx = existingCircle.x - circle.x
                    let dy = existingCircle.y - circle.y
                    let distance = sqrt(dx * dx + dy * dy)
                    if distance < (existingCircle.radius + circle.radius) {
                        isOverlapping = true
                        break
                    }
                }
            } while isOverlapping
            
            circles.append(circle)
        }
        return circles
    }
    
    private func triggerImmediateMovement(bounds: CGSize) {
        withAnimation(animationType) {
            movingCircles = movingCircles.map { circle in
                var updatedCircle = circle
                updatedCircle.x = Double.random(in: maxRadius...(bounds.width - maxRadius))
                updatedCircle.y = Double.random(in: maxRadius...(bounds.height - maxRadius))
                return updatedCircle
            }
        }
    }
}

#Preview {
    MovingCirclesView(
        circlesCount: 5,
        movementInterval: 2.0,
        minRadius: 30,
        maxRadius: 100,
        animationType: .linear(duration: 2.0),
        removeCircleOnTapped: true,
        fixedCircleColor: nil
    ) { circle in
        print("Circle tapped: \(circle.id)")
    } allCirclesCleared: {
        print("All circles cleared")
    }
}
