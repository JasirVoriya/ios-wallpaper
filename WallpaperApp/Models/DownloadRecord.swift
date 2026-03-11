import Foundation
import SwiftData

@Model
final class DownloadRecord {
    var remoteID: String
    var author: String
    var width: Int?
    var height: Int?
    var sourcePageURLString: String?
    var downloadURLString: String?
    var downloadedAt: Date

    init(
        remoteID: String,
        author: String,
        width: Int? = nil,
        height: Int? = nil,
        sourcePageURLString: String? = nil,
        downloadURLString: String? = nil,
        downloadedAt: Date = .now
    ) {
        self.remoteID = remoteID
        self.author = author
        self.width = width
        self.height = height
        self.sourcePageURLString = sourcePageURLString
        self.downloadURLString = downloadURLString
        self.downloadedAt = downloadedAt
    }

    convenience init(from wallpaper: Wallpaper, downloadedAt: Date = .now) {
        self.init(
            remoteID: wallpaper.id,
            author: wallpaper.author,
            width: wallpaper.width,
            height: wallpaper.height,
            sourcePageURLString: wallpaper.sourcePageURL.absoluteString,
            downloadURLString: wallpaper.downloadURL.absoluteString,
            downloadedAt: downloadedAt
        )
    }

    var asWallpaper: Wallpaper {
        Wallpaper(
            id: remoteID,
            author: author,
            width: width ?? 1200,
            height: height ?? 2200,
            sourcePageURL: URL(string: sourcePageURLString ?? "https://picsum.photos/id/\(remoteID)") ?? fallbackURL,
            downloadURL: URL(string: downloadURLString ?? "https://picsum.photos/id/\(remoteID)/1200/2200") ?? fallbackURL
        )
    }

    private var fallbackURL: URL {
        URL(string: "https://picsum.photos")!
    }
}
