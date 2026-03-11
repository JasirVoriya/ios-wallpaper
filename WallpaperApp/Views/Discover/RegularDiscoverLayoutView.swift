import SwiftUI

struct RegularDiscoverLayoutView: View {
    let wallpapers: [Wallpaper]
    let recommendations: [WallpaperRecommendation]
    let favoriteIDs: Set<String>
    let isLoadingMore: Bool
    let selectedWallpaper: Wallpaper?
    let onSelect: (Wallpaper) -> Void
    let onLoadNextPageIfNeeded: (Wallpaper) async -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            wallpaperGrid
                .frame(maxWidth: 720)

            Group {
                if let selectedWallpaper {
                    WallpaperDetailView(
                        wallpaper: selectedWallpaper,
                        showsNavigationChrome: false
                    )
                } else {
                    DiscoverSelectionPlaceholderView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(.background.secondary, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        }
        .padding(24)
    }

    private var wallpaperGrid: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if recommendations.isEmpty == false {
                    recommendationSection
                }

                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: 240, maximum: 320), spacing: 16, alignment: .top)
                    ],
                    spacing: 16
                ) {
                    ForEach(wallpapers) { wallpaper in
                        Button {
                            onSelect(wallpaper)
                        } label: {
                            WallpaperGridItemView(
                                wallpaper: wallpaper,
                                isFavorite: favoriteIDs.contains(wallpaper.id),
                                isSelected: selectedWallpaper?.id == wallpaper.id
                            )
                        }
                        .buttonStyle(.plain)
                        .task {
                            await onLoadNextPageIfNeeded(wallpaper)
                        }
                    }
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 4)

            if isLoadingMore {
                ProgressView()
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                    .accessibilityLabel("加载更多壁纸")
            }
        }
    }

    private var recommendationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("为你推荐")
                    .font(.title3.weight(.semibold))
                Text("推荐理由直接展示在卡片里，便于理解排序依据。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(recommendations) { recommendation in
                        Button {
                            onSelect(recommendation.wallpaper)
                        } label: {
                            WallpaperRecommendationCardView(
                                recommendation: recommendation,
                                isSelected: selectedWallpaper?.id == recommendation.wallpaper.id
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }
}
