
//
//  AdConfig.swift
//  TapOnCircles
//

import Foundation

struct AdConfig {
    // MARK: - App ID
    /// This ID is used in Info.plist
    static let appId = "ca-app-pub-3940256099942544~1458002511" // Test ID
    
    // MARK: - Banner Ads
    static let bannerAdUnitId = "ca-app-pub-3940256099942544/2934735716" // Test ID
    // static let bannerAdUnitId = "ca-app-pub-6611665849437983/5357921819"
    
    // MARK: - Interstitial Ads
    static let gameOverInterstitialAdUnitId = "ca-app-pub-3940256099942544/4411468910" // Test ID
    //static let gameOverInterstitialAdUnitId = "ca-app-pub-6611665849437983/4961260599"
    
    static let levelCompleteInterstitialAdUnitId = "ca-app-pub-3940256099942544/4411468910" // Test ID
    
    // MARK: - Rewarded Ads (if you add them later)
    static let rewardedAdUnitId = "ca-app-pub-3940256099942544/1712485313" // Test ID
    
    // MARK: - Helper Methods
    /// Returns true if the app is using test ad units
    static var isUsingTestAds: Bool {
        // Check if the app ID contains the test ID prefix
        return appId.contains("3940256099942544")
    }
    
    /// Logs warning if using test ads in production build
    static func checkAdConfiguration() {
        #if !DEBUG
        if isUsingTestAds {
            print("⚠️ WARNING: You're using test ad units in a production build!")
        }
        #endif
    }
}
