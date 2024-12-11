//
//  StartScreenView.swift
//  Ding Dang Dong Colors
//
//  Created by Toni on 12/10/24.
//

import SwiftUI

struct StartScreenView: View {
    let RestartGameAction: () -> Void
    
    
    var body: some View {
        ZStack {
            Spacer()
            VStack {
                CustomButton(
                    label: "Start Game",
                    action: {
                        print("starting game ...")
                        RestartGameAction()
                })
            }
        }
        .padding(20)
    }
}

#Preview {
    StartScreenView {
        print("!")
    }
}
