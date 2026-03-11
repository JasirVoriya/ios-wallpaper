import Foundation

actor WallpaperRecommendationEngine {
    func rank(
        items: [Wallpaper],
        favorites: [FavoriteSnapshot],
        preferredOrientation: WallpaperOrientation
    ) -> [Wallpaper] {
        guard items.isEmpty == false else {
            return items
        }

        let favoredIDs = Set(favorites.map(\.remoteID))
        let favoredAuthors = Set(favorites.map { $0.author.lowercased() })
        let favoredOrientations = Set(favorites.map(\.orientation))

        return items.sorted { lhs, rhs in
            score(
                for: lhs,
                favoredIDs: favoredIDs,
                favoredAuthors: favoredAuthors,
                favoredOrientations: favoredOrientations,
                preferredOrientation: preferredOrientation
            ) > score(
                for: rhs,
                favoredIDs: favoredIDs,
                favoredAuthors: favoredAuthors,
                favoredOrientations: favoredOrientations,
                preferredOrientation: preferredOrientation
            )
        }
    }

    private func score(
        for wallpaper: Wallpaper,
        favoredIDs: Set<String>,
        favoredAuthors: Set<String>,
        favoredOrientations: Set<WallpaperOrientation>,
        preferredOrientation: WallpaperOrientation
    ) -> Int {
        var total = 0

        if favoredIDs.contains(wallpaper.id) {
            total += 120
        }

        if favoredAuthors.contains(wallpaper.author.lowercased()) {
            total += 60
        }

        if wallpaper.orientation == preferredOrientation {
            total += 30
        }

        if favoredOrientations.contains(wallpaper.orientation) {
            total += 20
        }

        total += max(0, min(wallpaper.height, wallpaper.width) / 200)
        return total
    }
}
