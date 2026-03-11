import SwiftData
import SwiftUI

struct DiscoverView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @Query(sort: \FavoriteWallpaper.savedAt, order: .reverse)
    private var favorites: [FavoriteWallpaper]

    @State private var viewModel = DiscoverViewModel()
    @State private var selectedWallpaper: Wallpaper?
    @State private var pendingReloadTask: Task<Void, Never>?

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
            } else if usesRegularLayout {
                RegularDiscoverLayoutView(
                    wallpapers: viewModel.wallpapers,
                    recommendations: viewModel.recommendations,
                    favoriteIDs: favoriteIDs,
                    isLoadingMore: viewModel.isLoadingMore,
                    selectedWallpaper: selectedWallpaper,
                    onSelect: selectWallpaper,
                    onLoadNextPageIfNeeded: loadNextPageIfNeeded
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
        .onChange(of: viewModel.wallpapers) { _, _ in
            syncSelection()
        }
        .onDisappear {
            pendingReloadTask?.cancel()
        }
    }

    private var wallpaperGrid: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if viewModel.recommendations.isEmpty == false {
                    recommendedSection
                }

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
                                isFavorite: favoriteIDs.contains(wallpaper.id),
                                isSelected: false
                            )
                        }
                        .buttonStyle(.plain)
                        .task {
                            await loadNextPageIfNeeded(wallpaper)
                        }
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

    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("为你推荐")
                    .font(.title3.weight(.semibold))
                Text("依据你的本地收藏、默认方向偏好和分辨率信号生成。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(viewModel.recommendations) { recommendation in
                        NavigationLink(value: recommendation.wallpaper) {
                            WallpaperRecommendationCardView(
                                recommendation: recommendation,
                                isSelected: false
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 2)
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
        syncSelection()
    }

    private func queueReload() {
        pendingReloadTask?.cancel()
        pendingReloadTask = Task { @MainActor in
            await reloadWallpapers()
        }
    }

    private func loadNextPageIfNeeded(_ wallpaper: Wallpaper) async {
        let preferences = PreferencesStore.ensureDefault(in: modelContext)
        await viewModel.loadNextPageIfNeeded(
            for: wallpaper,
            context: modelContext,
            preferences: preferences
        )
    }

    private func selectWallpaper(_ wallpaper: Wallpaper) {
        selectedWallpaper = wallpaper
    }

    private func syncSelection() {
        guard usesRegularLayout else {
            return
        }

        if let currentSelection = selectedWallpaper {
            selectedWallpaper = viewModel.wallpapers.first(where: { $0.id == currentSelection.id })
        } else {
            selectedWallpaper = viewModel.wallpapers.first
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

    private var usesRegularLayout: Bool {
        horizontalSizeClass == .regular
    }
}

#Preview {
    DiscoverView()
        .modelContainer(
            for: [FavoriteWallpaper.self, DownloadRecord.self, UserPreferences.self],
            inMemory: true
        )
}
