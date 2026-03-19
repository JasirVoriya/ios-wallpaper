import Foundation
import SwiftData

enum DownloadHistoryStore {
    @MainActor
    static func recordDownload(for wallpaper: Wallpaper, in context: ModelContext) throws {
        context.insert(DownloadRecord(from: wallpaper))
        try context.save()
    }
}
