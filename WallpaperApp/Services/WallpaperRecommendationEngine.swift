import Foundation

actor WallpaperRecommendationEngine {
    func rank(
        items: [Wallpaper],
        favorites: [FavoriteSnapshot],
        preferredOrientation: WallpaperOrientation
    ) -> [Wallpaper] {
        evaluations(
            for: items,
            favorites: favorites,
            preferredOrientation: preferredOrientation
        )
        .map(\.wallpaper)
    }

    func topRecommendations(
        items: [Wallpaper],
        favorites: [FavoriteSnapshot],
        preferredOrientation: WallpaperOrientation,
        limit: Int = 6
    ) -> [WallpaperRecommendation] {
        evaluations(
            for: items,
            favorites: favorites,
            preferredOrientation: preferredOrientation
        )
        .filter { $0.signals.isEmpty == false }
        .prefix(limit)
        .map { evaluation in
            let detailParts = Array((Array(evaluation.signals.dropFirst()) + evaluation.supporting).prefix(2))
            return WallpaperRecommendation(
                wallpaper: evaluation.wallpaper,
                headline: evaluation.signals[0],
                detail: detailParts.isEmpty ? "基于本地收藏与方向偏好生成" : detailParts.joined(separator: " · ")
            )
        }
    }

    private func evaluations(
        for items: [Wallpaper],
        favorites: [FavoriteSnapshot],
        preferredOrientation: WallpaperOrientation
    ) -> [WallpaperEvaluation] {
        guard items.isEmpty == false else {
            return []
        }

        let favoredIDs = Set(favorites.map(\.remoteID))
        let favoredAuthors = Set(favorites.map { $0.author.lowercased() })
        let favoredOrientations = Set(favorites.map(\.orientation))

        return items
            .map {
                evaluate(
                    wallpaper: $0,
                    favoredIDs: favoredIDs,
                    favoredAuthors: favoredAuthors,
                    favoredOrientations: favoredOrientations,
                    preferredOrientation: preferredOrientation
                )
            }
            .sorted { $0.score > $1.score }
    }

    private func evaluate(
        wallpaper: Wallpaper,
        favoredIDs: Set<String>,
        favoredAuthors: Set<String>,
        favoredOrientations: Set<WallpaperOrientation>,
        preferredOrientation: WallpaperOrientation
    ) -> WallpaperEvaluation {
        var total = 0
        var signals: [String] = []
        var supporting: [String] = []

        if favoredIDs.contains(wallpaper.id) {
            total += 120
            signals.append("你已经收藏过这张图")
        }

        if favoredAuthors.contains(wallpaper.author.lowercased()) {
            total += 60
            signals.append("作者与你收藏偏好一致")
        }

        if wallpaper.orientation == preferredOrientation {
            total += 30
            signals.append("符合你的默认方向偏好")
        }

        if favoredOrientations.contains(wallpaper.orientation) {
            total += 20
            signals.append("与你常收藏的方向一致")
        }

        if max(wallpaper.height, wallpaper.width) >= 2200 {
            total += 10
            supporting.append("高分辨率更适合锁屏与桌面")
        }

        total += max(0, min(wallpaper.height, wallpaper.width) / 200)

        return WallpaperEvaluation(
            wallpaper: wallpaper,
            score: total,
            signals: signals,
            supporting: supporting
        )
    }

    private struct WallpaperEvaluation: Sendable {
        let wallpaper: Wallpaper
        let score: Int
        let signals: [String]
        let supporting: [String]
    }
}
