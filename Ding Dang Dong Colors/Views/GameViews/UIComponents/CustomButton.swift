//
//  Button.swift
//  Ding Dang Dong Colors
//
//  Created by Toni Nichev on 12/7/24.
//

import SwiftUI

struct CustomButton: View {
    var label: String = "Restart"
    var colors: [Color] = [.red, .yellow, .green]
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .foregroundColor(.white)
                .cornerRadius(15)
                .shadow(radius: 5)
        }
    }
}


#Preview {
    CustomButton(label: "Restart", action: {
        print("Button tapped!")
    })
}
