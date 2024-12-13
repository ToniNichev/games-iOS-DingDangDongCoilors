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
    
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.purple, .pink]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            Spacer()
            VStack {
                CustomButton(
                    label: "Start Game",
                    action: {
                        print("starting game ...")
                        RestartGameAction()
                })
                
                CustomButton(label: "How To Play", action: {
                    isHowToPlayPresented = true
                })
                .fullScreenCover(isPresented: $isHowToPlayPresented) {
                    HowToPlayView()
                }
            }
            .padding(20)
        }
    }
}

#Preview {
    StartScreenView {
        print("!")
    }
}
