import Foundation

enum WallpaperOrientation: String, CaseIterable, Codable, Identifiable, Sendable {
    case portrait
    case landscape
    case square

    var id: String { rawValue }

    var localizedTitle: String {
        switch self {
        case .portrait:
            return NSLocalizedString("竖屏", comment: "Wallpaper orientation")
        case .landscape:
            return NSLocalizedString("横屏", comment: "Wallpaper orientation")
        case .square:
            return NSLocalizedString("方形", comment: "Wallpaper orientation")
        }
    }
}
