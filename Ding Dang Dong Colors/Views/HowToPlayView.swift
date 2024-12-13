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
                                gradient: Gradient(colors: [.blue, .purple]),
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
                    Text("Welcome to Matching Colors!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.purple)
                    
                    Text("Objective:")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    Text("Match the falling shapes with the correct shapes and colors before they reach the bottom of the screen. The game speeds up with each level, so stay focused!")
                        .font(.body)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.green.opacity(0.2))
                        )
                }
                .padding(.horizontal)
                
                // How to Play Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("How to Play:")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Label("1. Tap on the screen to change the bottom shape and color to match the falling one.", systemImage: "hand.tap.fill")
                        Label("2. The shapes will appear faster as you progress to higher levels.", systemImage: "speedometer")
                        Label("3. Tap on the moving circles in the background to earn bonus points.", systemImage: "circle.fill")
                        Label("4. Compete for the highest score on the leaderboard!", systemImage: "star.fill")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue.opacity(0.1))
                    )
                }
                .padding(.horizontal)
                
                // Game Controls Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Game Controls:")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Label("• Tap: Change the bottom shape and color to match the falling one.", systemImage: "hand.point.up.left.fill")
                        Label("• Tap Moving Circles: Earn bonus points by tapping the moving circles.", systemImage: "hand.tap.fill")
                        Label("• Restart: Tap the Restart button when the game ends to try again.", systemImage: "arrow.clockwise")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.pink.opacity(0.1))
                    )
                }
                .padding(.horizontal)
                
                // Tips Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Tips:")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Label("• Focus on speed and accuracy—each match earns points!", systemImage: "bolt.fill")
                        Label("• Tap the moving circles for bonus points.", systemImage: "gift.fill")
                        Label("• Practice to improve your reaction time and reach higher levels.", systemImage: "flame.fill")
                        Label("• Keep an eye on your score and level at the top of the screen.", systemImage: "eye.fill")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.orange.opacity(0.1))
                    )
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
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
