import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class DiscoverViewModel {
    private(set) var wallpapers: [Wallpaper] = []
    private(set) var recommendations: [WallpaperRecommendation] = []
    private(set) var isLoading = false
    private(set) var isLoadingMore = false
    private(set) var errorMessage: String?
    private(set) var hasLoadedOnce = false

    var searchText = ""
    var selectedOrientation: WallpaperOrientation = .portrait

    private let pageSize = 30
    private var currentPage = 1
    private var canLoadMorePages = true

    private let apiClient: WallpaperAPIClient
    private let recommendationEngine: WallpaperRecommendationEngine

    init(
        apiClient: WallpaperAPIClient = WallpaperAPIClient(),
        recommendationEngine: WallpaperRecommendationEngine = WallpaperRecommendationEngine()
    ) {
        self.apiClient = apiClient
        self.recommendationEngine = recommendationEngine
    }

    func loadInitial(using context: ModelContext, preferences: UserPreferences) async {
        isLoading = true
        errorMessage = nil
        currentPage = 1
        canLoadMorePages = true

        do {
            let fetched = try await apiClient.fetchWallpapers(page: currentPage, pageSize: pageSize, query: searchText)
            let filtered = filterByOrientation(fetched)
            let favoriteSnapshots = try favoriteSnapshotsIfNeeded(preferences: preferences, context: context)
            wallpapers = await rankIfNeeded(
                filtered,
                preferences: preferences,
                favorites: favoriteSnapshots
            )
            recommendations = await topRecommendationsIfNeeded(
                from: wallpapers,
                preferences: preferences,
                favorites: favoriteSnapshots
            )
            canLoadMorePages = fetched.count == pageSize
            hasLoadedOnce = true
        } catch is CancellationError {
            // Ignore cancellation from SwiftUI task lifecycle.
        } catch {
            errorMessage = error.localizedDescription
            recommendations = []
        }

        isLoading = false
    }

    func loadNextPageIfNeeded(for wallpaper: Wallpaper, context: ModelContext, preferences: UserPreferences) async {
        guard canLoadMorePages, isLoadingMore == false else {
            return
        }

        let triggerIndex = wallpapers.index(wallpapers.endIndex, offsetBy: -6, limitedBy: wallpapers.startIndex) ?? wallpapers.startIndex
        guard wallpapers.indices.contains(triggerIndex) else {
            return
        }

        guard wallpapers[triggerIndex].id == wallpaper.id else {
            return
        }

        isLoadingMore = true
        defer { isLoadingMore = false }

        do {
            currentPage += 1
            let fetched = try await apiClient.fetchWallpapers(page: currentPage, pageSize: pageSize, query: searchText)
            let filtered = filterByOrientation(fetched)
            let favoriteSnapshots = try favoriteSnapshotsIfNeeded(preferences: preferences, context: context)
            let ranked = await rankIfNeeded(
                filtered,
                preferences: preferences,
                favorites: favoriteSnapshots
            )
            wallpapers.append(contentsOf: ranked)
            recommendations = await topRecommendationsIfNeeded(
                from: wallpapers,
                preferences: preferences,
                favorites: favoriteSnapshots
            )
            canLoadMorePages = fetched.count == pageSize
        } catch is CancellationError {
            // Ignore cancellation from SwiftUI task lifecycle.
        } catch {
            currentPage = max(1, currentPage - 1)
            errorMessage = error.localizedDescription
        }
    }

    private func filterByOrientation(_ items: [Wallpaper]) -> [Wallpaper] {
        items.filter { $0.orientation == selectedOrientation }
    }

    private func rankIfNeeded(
        _ items: [Wallpaper],
        preferences: UserPreferences,
        favorites: [FavoriteSnapshot]
    ) async -> [Wallpaper] {
        guard preferences.enableIntelligentRecommendations else {
            return items
        }

        return await recommendationEngine.rank(
            items: items,
            favorites: favorites,
            preferredOrientation: preferences.preferredOrientation
        )
    }

    private func topRecommendationsIfNeeded(
        from items: [Wallpaper],
        preferences: UserPreferences,
        favorites: [FavoriteSnapshot]
    ) async -> [WallpaperRecommendation] {
        guard preferences.enableIntelligentRecommendations else {
            return []
        }

        return await recommendationEngine.topRecommendations(
            items: items,
            favorites: favorites,
            preferredOrientation: preferences.preferredOrientation
        )
    }

    private func favoriteSnapshotsIfNeeded(
        preferences: UserPreferences,
        context: ModelContext
    ) throws -> [FavoriteSnapshot] {
        guard preferences.enableIntelligentRecommendations else {
            return []
        }

        return try FavoriteStore.favoriteSnapshots(in: context)
    }
}
