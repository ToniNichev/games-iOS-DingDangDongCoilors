//
//  GameCenterView.swift
//  Ding Dang Dong Colors
//

import SwiftUI
import GameKit

// SwiftUI wrapper for Game Center view
struct GameCenterView: UIViewControllerRepresentable {
    var state: GKGameCenterViewControllerState = .leaderboards
    
    func makeUIViewController(context: Context) -> GKGameCenterViewController {
        let viewController = GKGameCenterViewController()
        viewController.gameCenterDelegate = context.coordinator
        viewController.viewState = state
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: GKGameCenterViewController, context: Context) {
        // Nothing to update
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, GKGameCenterControllerDelegate {
        func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
            gameCenterViewController.dismiss(animated: true)
        }
    }
}

#Preview {
    GameCenterView()
}
