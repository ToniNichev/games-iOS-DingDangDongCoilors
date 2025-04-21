import SwiftUI

struct TimerAnimationView: View {
    let timeRemaining: Int
    let totalTime: Int
    
    @State private var isAnimating = false
    
    private var percentage: Double {
        Double(timeRemaining) / Double(totalTime)
    }
    
    private var color: Color {
        if percentage > 0.6 {
            return .green
        } else if percentage > 0.3 {
            return .yellow
        } else {
            return .red
        }
    }
    
    var body: some View {
        ZStack {
            // Base circle
            Circle()
                .stroke(lineWidth: 15)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            // Progress circle
            Circle()
                .trim(from: 0.0, to: CGFloat(percentage))
                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: timeRemaining)
            
            // Timer text
            VStack {
                Text("\(timeRemaining)")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("seconds")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            // Pulsing circle for urgency when time is low
            if percentage <= 0.3 {
                Circle()
                    .stroke(Color.red, lineWidth: 5)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .opacity(isAnimating ? 0.0 : 0.5)
                    .animation(
                        Animation.easeInOut(duration: 1)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                    .onAppear {
                        isAnimating = true
                    }
            }
        }
        .frame(width: 90, height: 90)
        .padding()
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        TimerAnimationView(timeRemaining: 15, totalTime: 30)
    }
}
