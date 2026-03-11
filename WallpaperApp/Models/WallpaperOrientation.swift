import Foundation

enum WallpaperOrientation: String, CaseIterable, Codable, Identifiable, Sendable {
    case portrait
    case landscape
    case square

    var id: String { rawValue }

    var localizedTitle: String {
        switch self {
        case .portrait:
            return "竖屏"
        case .landscape:
            return "横屏"
        case .square:
            return "方形"
        }
    }
}
