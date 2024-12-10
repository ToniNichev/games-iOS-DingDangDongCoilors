//
//  GameOverAnimationView.swift
//  Ding Dang Dong Colors
//
//  Created by Toni Nichev on 12/6/24.
//

import SwiftUI

struct GameOverContentView: View {
    @State private var animationComplete = false
    @State private var showConfetti = false
    let RestartGameAction: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.purple, .pink]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                Text("GAME OVER")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .scaleEffect(showConfetti ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: showConfetti)
                
                Spacer()
                
                VStack(spacing: 20) {
                    CustomButton(label: "Play Again") {
                        RestartGameAction()
                    }
                    
                    CustomButton(label: "View Leaderboard") {
                        print("!!!!!")
                    }
                    
                    CustomButton(label: "Back To Start", colors:[.white, .purple], action:  {
                        print("2222")
                    })
                }
                .padding()
            }
        }
        .onAppear() {
            showConfetti = true
        }
    }
}

#Preview {
    GameOverContentView() {
        print("Restarting game ...")
    }
}
