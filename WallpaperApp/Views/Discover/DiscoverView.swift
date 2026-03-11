import SwiftData
import SwiftUI

struct DiscoverView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @Query(sort: \FavoriteWallpaper.savedAt, order: .reverse)
    private var favorites: [FavoriteWallpaper]

    @State private var viewModel = DiscoverViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading, viewModel.wallpapers.isEmpty {
                ProgressView("正在加载壁纸")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage, viewModel.wallpapers.isEmpty {
                WallpaperEmptyStateView(
                    title: "加载失败",
                    message: errorMessage,
                    systemImage: "wifi.exclamationmark"
                )
            } else if viewModel.wallpapers.isEmpty {
                WallpaperEmptyStateView(
                    title: "没有找到匹配壁纸",
                    message: "试试调整方向筛选或换一个关键词。",
                    systemImage: "magnifyingglass"
                )
            } else {
                wallpaperGrid
            }
        }
        .navigationTitle("壁纸")
        .searchable(text: $viewModel.searchText, prompt: "按作者或编号搜索")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                orientationMenu
            }
        }
        .navigationDestination(for: Wallpaper.self) { wallpaper in
            WallpaperDetailView(wallpaper: wallpaper)
        }
        .task {
            await prepareInitialLoadIfNeeded()
        }
        .refreshable {
            await reloadWallpapers()
        }
        .onSubmit(of: .search) {
            queueReload()
        }
        .onChange(of: viewModel.searchText) { _, newValue in
            guard newValue.isEmpty else {
                return
            }

            queueReload()
        }
        .onChange(of: viewModel.selectedOrientation) { _, _ in
            queueReload()
        }
    }

    private var wallpaperGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: gridMinimumWidth, maximum: 320), spacing: gridSpacing, alignment: .top)
                ],
                spacing: gridSpacing
            ) {
                ForEach(viewModel.wallpapers) { wallpaper in
                    NavigationLink(value: wallpaper) {
                        WallpaperGridItemView(
                            wallpaper: wallpaper,
                            isFavorite: favoriteIDs.contains(wallpaper.id)
                        )
                    }
                    .buttonStyle(.plain)
                    .task {
                        let preferences = PreferencesStore.ensureDefault(in: modelContext)
                        await viewModel.loadNextPageIfNeeded(
                            for: wallpaper,
                            context: modelContext,
                            preferences: preferences
                        )
                    }
                }
            }
            .padding(.horizontal, gridHorizontalPadding)
            .padding(.vertical, 12)

            if viewModel.isLoadingMore {
                ProgressView()
                    .padding(.bottom, 20)
                    .accessibilityLabel("加载更多壁纸")
            }
        }
    }

    private var orientationMenu: some View {
        Menu {
            Picker("方向", selection: $viewModel.selectedOrientation) {
                ForEach(WallpaperOrientation.allCases) { orientation in
                    Text(orientation.localizedTitle).tag(orientation)
                }
            }
        } label: {
            Label("筛选方向", systemImage: "line.3.horizontal.decrease.circle")
        }
        .accessibilityLabel("选择壁纸方向")
    }

    private var favoriteIDs: Set<String> {
        Set(favorites.map(\.remoteID))
    }

    private func prepareInitialLoadIfNeeded() async {
        _ = PreferencesStore.ensureDefault(in: modelContext)

        guard viewModel.hasLoadedOnce == false else {
            return
        }

        await reloadWallpapers()
    }

    private func reloadWallpapers() async {
        let preferences = PreferencesStore.ensureDefault(in: modelContext)
        await viewModel.loadInitial(using: modelContext, preferences: preferences)
    }

    private func queueReload() {
        Task { @MainActor in
            await reloadWallpapers()
        }
    }

    private var gridMinimumWidth: CGFloat {
        horizontalSizeClass == .regular ? 240 : 160
    }

    private var gridHorizontalPadding: CGFloat {
        horizontalSizeClass == .regular ? 24 : 16
    }

    private var gridSpacing: CGFloat {
        horizontalSizeClass == .regular ? 16 : 12
    }
}

#Preview {
    DiscoverView()
        .modelContainer(
            for: [FavoriteWallpaper.self, DownloadRecord.self, UserPreferences.self],
            inMemory: true
        )
}
