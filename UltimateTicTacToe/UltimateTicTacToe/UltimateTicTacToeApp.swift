import SwiftUI
import AVFoundation

@main
struct MyApp: App {
//    init() {
//        AVPlayer.setupBgMusic()
//        AVPlayer.bgQueuePlayer.play()
//    }
    
    var body: some Scene {
        WindowGroup {
            MainPage()
                .modelContainer(for: History.self)
        }
    }
}


#Preview {
    MainPage()
}
