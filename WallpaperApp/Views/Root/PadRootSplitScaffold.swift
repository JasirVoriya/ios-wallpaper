import SwiftUI

struct PadRootSplitScaffold: View {
    @Binding var selectedTab: RootTab

    var body: some View {
        NavigationSplitView {
            List(selection: sidebarSelection) {
                ForEach(RootTab.allCases) { tab in
                    Label(tab.title, systemImage: tab.systemImage)
                        .tag(tab as RootTab?)
                }
            }
            .navigationTitle("WallpaperApp")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.sidebar)
            .navigationSplitViewColumnWidth(min: 220, ideal: 240, max: 280)
        } detail: {
            NavigationStack {
                RootTabContentView(tab: selectedTab)
            }
        }
        .navigationSplitViewStyle(.balanced)
    }

    private var sidebarSelection: Binding<RootTab?> {
        Binding(
            get: { selectedTab },
            set: { newValue in
                guard let newValue else {
                    return
                }

                selectedTab = newValue
            }
        )
    }
}
