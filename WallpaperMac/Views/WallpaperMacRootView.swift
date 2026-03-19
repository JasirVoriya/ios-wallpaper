import SwiftUI

struct WallpaperMacRootView: View {
    @State private var selection: WallpaperMacSection? = .discover

    var body: some View {
        NavigationSplitView {
            List(WallpaperMacSection.allCases, selection: $selection) { section in
                Label(section.title, systemImage: section.systemImage)
            }
            .navigationTitle("WallpaperApp")
        } detail: {
            WallpaperMacDetailPlaceholder(section: selection ?? .discover)
        }
        .toolbar {
            ToolbarItemGroup {
                Button("Refresh") {}
                    .disabled(true)
                Button("Save") {}
                    .disabled(true)
            }
        }
    }
}

private struct WallpaperMacDetailPlaceholder: View {
    let section: WallpaperMacSection

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(section.title)
                .font(.largeTitle.weight(.semibold))
            Text("Native macOS shell scaffold for the active multiplatform architecture track.")
                .foregroundStyle(.secondary)
            Text("Current phase: shared source roots, app targets, and verification targets.")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(32)
    }
}

#Preview {
    WallpaperMacRootView()
}
