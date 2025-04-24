import SwiftUI

struct TimerView: View {
    @State private var timeRemaining: Int
    @State private var timer: Timer? = nil
    
    init(seconds: Int) {
        self._timeRemaining = State(initialValue: seconds)
    }
    
    var body: some View {
        Text("\(timeRemaining)s")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.purple)
            .onAppear {
                startTimer()
            }
            .onDisappear {
                timer?.invalidate()
            }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
            }
        }
    }
}
