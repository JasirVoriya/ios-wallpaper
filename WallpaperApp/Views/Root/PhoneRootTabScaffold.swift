import SwiftUI

struct PhoneRootTabScaffold: View {
    @Binding var selectedTab: RootTab

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(RootTab.allCases) { tab in
                NavigationStack {
                    RootTabContentView(tab: tab)
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.systemImage)
                }
                .tag(tab)
            }
        }
    }
}
