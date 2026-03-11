import Foundation

struct WallpaperRecommendation: Identifiable, Hashable, Sendable {
    let wallpaper: Wallpaper
    let headline: String
    let detail: String

    var id: String {
        wallpaper.id
    }
}
