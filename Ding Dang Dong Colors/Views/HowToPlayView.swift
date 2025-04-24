//
//  HowToPlayView.swift
//  Ding Dang Dong Colors
//

import SwiftUI

struct HowToPlayView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Animation states
    @State private var animateTitle = false
    @State private var animateContent = false
    @State private var animateButton = false
    
    // Circle animation states
    @State private var circlePositions: [CGPoint] = Array(repeating: CGPoint(x: 0, y: 0), count: 5)
    @State private var circleOpacities: [Double] = Array(repeating: 0.0, count: 5)
    @State private var circleScales: [CGFloat] = Array(repeating: 1.0, count: 5)
    
    let colors: [Color] = [.red, .blue, .green, .yellow, .orange]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient - matching StartScreenView
                LinearGradient(
                    gradient: Gradient(colors: [.purple, .pink]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                // Animated background circles (matching start screen)
                ForEach(0..<5) { index in
                    Circle()
                        .fill(colors[index].opacity(0.4))
                        .frame(width: 70 + CGFloat(index * 12), height: 70 + CGFloat(index * 12))
                        .position(circlePositions[index])
                        .opacity(circleOpacities[index])
                        .scaleEffect(circleScales[index])
                        .animation(
                            Animation.easeInOut(duration: Double(4 + index))
                                .repeatForever(autoreverses: true),
                            value: circlePositions[index]
                        )
                }
                
                // Main content
                VStack(spacing: min(geometry.size.height * 0.02, 15)) {
                    // Title with animation
                    Text("HOW TO PLAY")
                        .font(.system(size: min(geometry.size.width * 0.1, 32), weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, geometry.size.height * 0.05)
                        .padding(.bottom, geometry.size.height * 0.02)
                        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 3)
                        .opacity(animateTitle ? 1 : 0)
                        .offset(y: animateTitle ? 0 : -30)
                    
                    // Content with animation
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // Main objectives section
                            instructionSection(
                                title: "Main Objectives",
                                instructions: [
                                    instructionItem(icon: "hand.tap.fill", color: .blue, text: "Tap colored circles to earn points"),
                                    instructionItem(icon: "xmark.circle.fill", color: .black, text: "Avoid black mines or lose a life"),
                                    instructionItem(icon: "timer", color: .yellow, text: "Complete each level before time runs out"),
                                    instructionItem(icon: "arrow.up.circle.fill", color: .green, text: "Clear all circles to advance to the next level")
                                ]
                            )
                            
                            // Power-ups section
                            instructionSection(
                                title: "Power-ups",
                                instructions: [
                                    instructionItem(icon: "heart.fill", color: .red, text: "Hearts give you an extra life"),
                                    instructionItem(icon: "clock.fill", color: .blue, text: "Clocks add more time to the timer"),
                                    instructionItem(icon: "arrow.counterclockwise.circle.fill", color: .purple, text: "Speed potions slow down the game temporarily")
                                ]
                            )
                            
                            // Game mechanics section
                            instructionSection(
                                title: "Game Mechanics",
                                instructions: [
                                    instructionItem(icon: "speedometer", color: .orange, text: "Game speed increases with each level"),
                                    instructionItem(icon: "number.circle.fill", color: .green, text: "More circles and mines appear at higher levels"),
                                    instructionItem(icon: "trophy.fill", color: .yellow, text: "Aim for the highest score and compete on the leaderboard")
                                ]
                            )
                            
                            // Tips section
                            instructionSection(
                                title: "Tips & Tricks",
                                instructions: [
                                    instructionItem(icon: "lightbulb.fill", color: .yellow, text: "Prioritize collecting power-ups when they appear"),
                                    instructionItem(icon: "exclamationmark.triangle.fill", color: .orange, text: "Watch your timer - it gets shorter at higher levels!"),
                                    instructionItem(icon: "hand.raised.fill", color: .blue, text: "Be patient at higher levels - slow and steady wins!")
                                ]
                            )
                        }
                        .padding(.horizontal, 20)
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 30)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Close button with animation - matching CustomButton style
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("READY TO PLAY!")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(minWidth: 200, minHeight: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.purple.opacity(0.8), .pink.opacity(0.8)]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
                            )
                    }
                    .padding(.bottom, geometry.size.height * 0.05)
                    .opacity(animateButton ? 1 : 0)
                    .offset(y: animateButton ? 0 : 30)
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    // Helper function to create an instruction section
    func instructionSection(title: String, instructions: [some View]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            // Divider line
            Rectangle()
                .frame(height: 2)
                .foregroundColor(.white.opacity(0.3))
                .padding(.bottom, 5)
            
            // Instruction items
            ForEach(0..<instructions.count, id: \.self) { index in
                instructions[index]
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    // Helper function to create an instruction item
    func instructionItem(icon: String, color: Color, text: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 25)
            
            Text(text)
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(.white)
            
            Spacer()
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
            
            circleOpacities[i] = Double.random(in: 0.2...0.4) // Same as start screen
            circleScales[i] = CGFloat.random(in: 0.8...1.2)
        }
        
        // Start animations with delays
        withAnimation(.easeOut(duration: 0.7)) {
            animateTitle = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.7)) {
                animateContent = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeOut(duration: 0.7)) {
                animateButton = true
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
            withAnimation(.easeInOut(duration: Double.random(in: 4.0...7.0))) {
                circlePositions[i] = CGPoint(
                    x: CGFloat.random(in: 100...screenWidth-100),
                    y: CGFloat.random(in: 100...screenHeight-100)
                )
                
                circleOpacities[i] = Double.random(in: 0.2...0.4) // Same as start screen
                circleScales[i] = CGFloat.random(in: 0.8...1.2)
            }
        }
        
        // Schedule the next update
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            updateCirclePositions()
        }
    }
}

#Preview {
    HowToPlayView()
}
