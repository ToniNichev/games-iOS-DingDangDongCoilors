import GoogleMobileAds

class InterstitialAdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    @Published var interstitialAd: InterstitialAd?
    let adUnitID = "ca-app-pub-3940256099942544/4411468910" // Test ID
    
    func loadAd() {
        InterstitialAd.load(with: adUnitID, request: Request()) { [weak self] ad, error in
            if let error = error {
                print("Failed to load ad: \(error.localizedDescription)")
                return
            }
            self?.interstitialAd = ad
            self?.interstitialAd?.fullScreenContentDelegate = self
        }
    }
    
    func showAd() {
        guard let ad = interstitialAd,
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        ad.present(from: rootViewController)
    }
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        loadAd() // Load next ad
    }
}
