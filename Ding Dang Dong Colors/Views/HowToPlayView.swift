import SwiftUI

struct HowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Title Section
                VStack(spacing: 10) {
                    Text("How To Play")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.red, .green]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .cornerRadius(15)
                            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
                        )
                }
                .padding(.bottom, 20)
                
                // Welcome Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Welcome to Ding Dang Dong Colors!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.purple)
                    
                    Text("Objective:")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    Text("Tap colored circles to score points while avoiding black mines. As you progress through levels, the game gets faster and more challenging. Race against the timer and collect power-ups to survive longer!")
                        .font(.body)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.green.opacity(0.2))
                        )
                }
                .padding(.horizontal)
                
                // Basic Game Rules
                VStack(alignment: .leading, spacing: 15) {
                    Text("Basic Game Rules:")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Tap on colored circles to earn points", systemImage: "hand.tap.fill")
                        Label("Avoid tapping black circles (mines) which will cost you a life", systemImage: "xmark.circle.fill")
                        Label("Clear all colored circles to advance to the next level", systemImage: "arrow.up.circle.fill")
                        Label("Keep an eye on the timer at the top - when it runs out, the game ends", systemImage: "clock.fill")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue.opacity(0.1))
                    )
                }
                .padding(.horizontal)
                
                // Power-Ups Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Power-Ups:")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        // Heart power-up
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 24))
                                .frame(width: 30)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Falling Hearts")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                
                                Text("Tap on falling hearts to gain an extra life. Hearts fall less frequently in higher levels.")
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                        // Clock power-up
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 24))
                                .frame(width: 30)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Falling Clocks")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                
                                Text("Tap on falling clocks to add extra seconds to your timer. The time bonus decreases in higher levels.")
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.pink.opacity(0.1))
                    )
                }
                .padding(.horizontal)
                
                // Difficulty Progression
                VStack(alignment: .leading, spacing: 15) {
                    Text("Level Progression:")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Each level adds more circles and mines", systemImage: "plus.circle.fill")
                        Label("Movement speed increases with each level", systemImage: "hare.fill")
                        Label("Timer duration decreases as you progress", systemImage: "timer")
                        Label("Power-ups become rarer and fall faster in higher levels", systemImage: "arrow.down.circle.fill")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.orange.opacity(0.1))
                    )
                }
                .padding(.horizontal)
                
                // Tips Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Pro Tips:")
                        .font(.headline)
                        .foregroundColor(.yellow)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Prioritize catching hearts when low on lives", systemImage: "heart.fill")
                        Label("Go for clock power-ups when the timer is running low", systemImage: "clock.fill")
                        Label("Balance risk and reward - sometimes it's better to focus on clearing circles than chasing power-ups", systemImage: "scale.3d")
                        Label("Compete for high scores on the Game Center leaderboard!", systemImage: "crown.fill")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.purple.opacity(0.1))
                    )
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.red.opacity(0.1), Color.green.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .overlay(
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                            .padding()
                            .background(Color.white.opacity(0.7))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                }
                Spacer()
            }
            .padding()
        )
        .navigationTitle("How To Play")
    }
}

#Preview {
    HowToPlayView()
}
