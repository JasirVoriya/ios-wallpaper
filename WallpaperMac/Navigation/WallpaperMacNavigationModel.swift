import Foundation

enum WallpaperMacSection: String, CaseIterable, Identifiable {
    case discover
    case favorites
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .discover:
            return "Discover"
        case .favorites:
            return "Favorites"
        case .settings:
            return "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .discover:
            return "sparkles.rectangle.stack"
        case .favorites:
            return "heart"
        case .settings:
            return "gearshape"
        }
    }
}
