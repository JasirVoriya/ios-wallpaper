import Foundation
import SwiftData

enum FavoriteStore {
    @MainActor
    static func favoriteSnapshots(in context: ModelContext) throws -> [FavoriteSnapshot] {
        let favorites = try context.fetch(FetchDescriptor<FavoriteWallpaper>())
        return favorites.map {
            FavoriteSnapshot(remoteID: $0.remoteID, author: $0.author, orientation: $0.asWallpaper.orientation)
        }
    }

    @MainActor
    static func contains(_ wallpaper: Wallpaper, in context: ModelContext) throws -> Bool {
        let remoteID = wallpaper.id
        let descriptor = FetchDescriptor<FavoriteWallpaper>(
            predicate: #Predicate { $0.remoteID == remoteID }
        )
        return try context.fetchCount(descriptor) > 0
    }

    @MainActor
    static func toggle(_ wallpaper: Wallpaper, in context: ModelContext) throws -> Bool {
        let remoteID = wallpaper.id
        let descriptor = FetchDescriptor<FavoriteWallpaper>(
            predicate: #Predicate { $0.remoteID == remoteID }
        )
        let matchingFavorites = try context.fetch(descriptor)

        if let existing = matchingFavorites.first {
            context.delete(existing)
            try context.save()
            return false
        }

        context.insert(FavoriteWallpaper(from: wallpaper))
        try context.save()
        return true
    }
}
