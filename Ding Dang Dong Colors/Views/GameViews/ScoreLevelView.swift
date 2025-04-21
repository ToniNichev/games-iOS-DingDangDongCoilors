import SwiftUI

struct ScoreLevelView: View {
    let score: Int
    let level: Int
    let lives: Int
    let maxLives: Int
    let gradientColors: [Color]
    
    var body: some View {
        HStack(spacing: 20) {
            // Score UI
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 30))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Score")
                        .font(.caption)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                    Text("\(score)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .shadow(radius: 5)
                }
            }
            
            // Level UI
            HStack {
                Image(systemName: "arrow.up.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 30))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Level")
                        .font(.caption)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                    Text("\(level)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                        .shadow(radius: 5)
                }
            }
            
            if lives > 0 {
                // Lives UI
                VStack {
                    Text("Lives")
                        .font(.caption)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                    HStack(spacing: 2) {
                        ForEach(0..<maxLives, id: \.self) { index in
                            Image(systemName: index < lives ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                        }
                    }
                    .padding(.top, 0.2)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    gradient: Gradient(colors: gradientColors),
                    startPoint: .top,
                    endPoint: .bottom
                ))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.5), lineWidth: 2)
        )
        .shadow(radius: 10)
        .animation(.easeInOut, value: score) // Animate score changes
        .animation(.easeInOut, value: level) // Animate level changes
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("Score and Level"))
        .accessibilityValue(Text("Score \(score), Level \(level)"))
    }
}

#Preview {
    ScoreLevelView(
        score: 199,
        level: 4,
        lives: 3,
        maxLives: 3,
        gradientColors: [.blue.opacity(0.7), .purple.opacity(0.7)])
}
