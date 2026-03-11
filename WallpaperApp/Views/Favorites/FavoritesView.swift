import SwiftData
import SwiftUI

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @Query(sort: \FavoriteWallpaper.savedAt, order: .reverse)
    private var favorites: [FavoriteWallpaper]

    var body: some View {
        Group {
            if favorites.isEmpty {
                WallpaperEmptyStateView(
                    title: "暂无收藏",
                    message: "在发现页点“收藏”后，这里会自动同步。",
                    systemImage: "heart.slash"
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                favoritesList
            }
        }
        .navigationTitle("收藏")
        .navigationDestination(for: Wallpaper.self) { wallpaper in
            WallpaperDetailView(wallpaper: wallpaper)
        }
    }

    private var favoritesList: some View {
        Group {
            if horizontalSizeClass == .regular {
                favoritesListBody
                    .listStyle(.insetGrouped)
            } else {
                favoritesListBody
                    .listStyle(.plain)
            }
        }
    }

    private var favoritesListBody: some View {
        List {
            ForEach(favorites) { favorite in
                NavigationLink(value: favorite.asWallpaper) {
                    HStack(spacing: 12) {
                        AsyncImage(url: favorite.asWallpaper.thumbnailURL) { phase in
                            switch phase {
                            case let .success(image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure, .empty:
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.quaternary)
                                    .overlay {
                                        Image(systemName: "photo")
                                            .foregroundStyle(.secondary)
                                    }
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 64, height: 88)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                        VStack(alignment: .leading, spacing: 6) {
                            Text(favorite.author)
                                .font(.headline)
                            Text(favorite.asWallpaper.orientation.localizedTitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .onDelete(perform: deleteFavorites)
        }
    }

    private func deleteFavorites(at offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(favorites[offset])
        }

        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
        }
    }
}

#Preview {
    FavoritesView()
        .modelContainer(
            for: [FavoriteWallpaper.self, DownloadRecord.self, UserPreferences.self],
            inMemory: true
        )
}
