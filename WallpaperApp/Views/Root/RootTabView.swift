import SwiftUI

struct RootTabView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State private var selectedTab: RootTab = .discover

    var body: some View {
        Group {
            if usesSplitNavigation {
                PadRootSplitScaffold(selectedTab: $selectedTab)
            } else {
                PhoneRootTabScaffold(selectedTab: $selectedTab)
            }
        }
    }

    private var usesSplitNavigation: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
}

#Preview {
    RootTabView()
        .environment(AppServices())
        .modelContainer(
            for: [FavoriteWallpaper.self, DownloadRecord.self, UserPreferences.self],
            inMemory: true
        )
}
