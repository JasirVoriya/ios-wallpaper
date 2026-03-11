import SwiftUI

struct RootTabContentView: View {
    let tab: RootTab

    var body: some View {
        switch tab {
        case .discover:
            DiscoverView()
        case .favorites:
            FavoritesView()
        case .settings:
            SettingsView()
        }
    }
}
