import SwiftUI

@main
struct WallpaperAppMacApp: App {
    var body: some Scene {
        WindowGroup {
            WallpaperMacRootView()
        }
        .defaultSize(width: 1180, height: 760)
    }
}
