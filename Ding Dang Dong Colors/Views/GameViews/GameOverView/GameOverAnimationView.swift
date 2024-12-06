//
//  GameOverAnimationView.swift
//  Ding Dang Dong Colors
//
//  Created by Toni Nichev on 12/6/24.
//

import SwiftUI

struct GameOverAnimationView: View {
    @State private var animationComplete = false
    let onAnimationComplete: () -> Void
    
    var body: some View {
        ZStack {
            // Dark background with a fade-in effect
            Color.black
                .opacity(animationComplete ? 0.8 : 0.0)
                .animation(.easeInOut(duration: 1.0), value: animationComplete)
                .edgesIgnoringSafeArea(.all)
            
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    animationComplete = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    //onAnimationComplete()
                }
            }
        }
    }
}

#Preview {
    GameOverAnimationView {
        
    }
}
