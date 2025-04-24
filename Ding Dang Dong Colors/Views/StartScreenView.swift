//
//  StartScreenView.swift
//  Ding Dang Dong Colors
//
//  Created by Toni on 12/10/24.
//

import SwiftUI

struct StartScreenView: View {
    @State private var isHowToPlayPresented = false
    let RestartGameAction: () -> Void
    
    // Animation states
    @State private var animateTitle = false
    @State private var animateSubtitle = false
    @State private var animateButtons = false
    @State private var pulsatePlayButton = false
    
    // Circle animation states
    @State private var circlePositions: [CGPoint] = Array(repeating: CGPoint(x: 0, y: 0), count: 5)
    @State private var circleOpacities: [Double] = Array(repeating: 0.0, count: 5)
    @State private var circleScales: [CGFloat] = Array(repeating: 1.0, count: 5)
    
    let colors: [Color] = [.red, .blue, .green, .yellow, .orange]
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [.purple, .pink]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // Animated background circles
            ForEach(0..<5) { index in
                Circle()
                    .fill(colors[index].opacity(0.4))
                    .frame(width: 80 + CGFloat(index * 15), height: 80 + CGFloat(index * 15))
                    .position(circlePositions[index])
                    .opacity(circleOpacities[index])
                    .scaleEffect(circleScales[index])
                    .animation(
                        Animation.easeInOut(duration: Double(3 + index))
                            .repeatForever(autoreverses: true),
                        value: circlePositions[index]
                    )
            }
            
            // Main content
            VStack(spacing: 40) {
                Spacer()
                
                // Game title
                VStack(spacing: 10) {
                    Text("DING DANG DONG")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                        .offset(y: animateTitle ? 0 : -200)
                        .opacity(animateTitle ? 1 : 0)
                    
                    Text("COLORS")
                        .font(.system(size: 56, weight: .heavy, design: .rounded))
                        .foregroundColor(.yellow)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                        .offset(y: animateTitle ? 0 : -200)
                        .opacity(animateTitle ? 1 : 0)
                }
                
                // Game subtitle
                Text("TAP THE CIRCLES, AVOID THE MINES")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.3))
                    )
                    .offset(y: animateSubtitle ? 0 : 50)
                    .opacity(animateSubtitle ? 1 : 0)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 20) {
                    // Start Game button (using CustomButton but with animation)
                    CustomButton(
                        label: "Start Game",
                        action: {
                            print("starting game ...")
                            RestartGameAction()
                        }
                    )
                    .scaleEffect(pulsatePlayButton ? 1.05 : 1.0)
                    .offset(y: animateButtons ? 0 : 100)
                    .opacity(animateButtons ? 1 : 0)
                    
                    // How To Play button
                    CustomButton(
                        label: "How To Play",
                        action: {
                            isHowToPlayPresented = true
                        }
                    )
                    .fullScreenCover(isPresented: $isHowToPlayPresented) {
                        HowToPlayView()
                    }
                    .offset(y: animateButtons ? 0 : 100)
                    .opacity(animateButtons ? 1 : 0)
                }
                
                Spacer()
                
                // Banner Ad
                BannerAd(adUnitID: AdConfig.startGameBannerAdUnitId)
                    .frame(height: 50)
                    .opacity(animateButtons ? 1 : 0)
            }
            .padding(20)
        }
        .onAppear {
            startAnimations()
        }
    }
    
    // Start all animations
    func startAnimations() {
        // Generate random positions for background circles
        for i in 0..<circlePositions.count {
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            
            circlePositions[i] = CGPoint(
                x: CGFloat.random(in: 100...screenWidth-100),
                y: CGFloat.random(in: 100...screenHeight-100)
            )
            
            circleOpacities[i] = Double.random(in: 0.2...0.4)
            circleScales[i] = CGFloat.random(in: 0.8...1.2)
        }
        
        // Start animations with delays
        withAnimation(.easeOut(duration: 1.0)) {
            animateTitle = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeOut(duration: 1.0)) {
                animateSubtitle = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeOut(duration: 1.0)) {
                animateButtons = true
            }
            
            // Start button pulsing animation
            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulsatePlayButton = true
            }
        }
        
        // Animate circle positions periodically
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            updateCirclePositions()
        }
    }
    
    // Update circle positions periodically
    func updateCirclePositions() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        for i in 0..<circlePositions.count {
            withAnimation(.easeInOut(duration: Double.random(in: 3.0...6.0))) {
                circlePositions[i] = CGPoint(
                    x: CGFloat.random(in: 100...screenWidth-100),
                    y: CGFloat.random(in: 100...screenHeight-100)
                )
                
                circleOpacities[i] = Double.random(in: 0.2...0.4)
                circleScales[i] = CGFloat.random(in: 0.8...1.2)
            }
        }
        
        // Schedule the next update
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            updateCirclePositions()
        }
    }
}

#Preview {
    StartScreenView {
        print("!")
    }
}
