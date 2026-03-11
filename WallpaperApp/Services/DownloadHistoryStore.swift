import Foundation
import SwiftData

enum DownloadHistoryStore {
    @MainActor
    static func recordDownload(for wallpaper: Wallpaper, in context: ModelContext) throws {
        context.insert(DownloadRecord(remoteID: wallpaper.id, author: wallpaper.author))
        try context.save()
    }
}
