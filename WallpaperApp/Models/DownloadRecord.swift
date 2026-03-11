import Foundation
import SwiftData

@Model
final class DownloadRecord {
    var remoteID: String
    var author: String
    var downloadedAt: Date

    init(remoteID: String, author: String, downloadedAt: Date = .now) {
        self.remoteID = remoteID
        self.author = author
        self.downloadedAt = downloadedAt
    }
}
