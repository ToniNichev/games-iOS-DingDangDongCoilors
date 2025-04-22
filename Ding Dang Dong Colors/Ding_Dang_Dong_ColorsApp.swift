//
//  Ding_Dang_Dong_ColorsApp.swift
//  Ding Dang Dong Colors
//
//  Created by Toni on 12/5/24.
//

import SwiftUI
import GoogleMobileAds

@main
struct Ding_Dang_Dong_ColorsApp: App {
    init() {
        MobileAds.shared.start(completionHandler: nil)
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
