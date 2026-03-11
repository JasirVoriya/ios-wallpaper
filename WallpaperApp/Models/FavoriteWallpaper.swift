import Foundation
import SwiftData

@Model
final class FavoriteWallpaper {
    @Attribute(.unique) var remoteID: String
    var author: String
    var width: Int
    var height: Int
    var sourcePageURLString: String
    var previewURLString: String
    var downloadURLString: String
    var savedAt: Date

    init(from wallpaper: Wallpaper, savedAt: Date = .now) {
        self.remoteID = wallpaper.id
        self.author = wallpaper.author
        self.width = wallpaper.width
        self.height = wallpaper.height
        self.sourcePageURLString = wallpaper.sourcePageURL.absoluteString
        self.previewURLString = wallpaper.previewURL.absoluteString
        self.downloadURLString = wallpaper.downloadURL.absoluteString
        self.savedAt = savedAt
    }

    var asWallpaper: Wallpaper {
        Wallpaper(
            id: remoteID,
            author: author,
            width: width,
            height: height,
            sourcePageURL: URL(string: sourcePageURLString) ?? URL(string: "https://picsum.photos")!,
            downloadURL: URL(string: downloadURLString) ?? URL(string: "https://picsum.photos/id/\(remoteID)/1200/2200")!
        )
    }
}
