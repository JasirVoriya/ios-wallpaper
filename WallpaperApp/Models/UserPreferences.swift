import Foundation
import SwiftData

@Model
final class UserPreferences {
    static let singletonKey = "default-user-preferences"

    @Attribute(.unique) var key: String
    var enableIntelligentRecommendations: Bool
    var preferredOrientationRawValue: String
    var updatedAt: Date

    init(
        key: String = singletonKey,
        enableIntelligentRecommendations: Bool = true,
        preferredOrientation: WallpaperOrientation = .portrait,
        updatedAt: Date = .now
    ) {
        self.key = key
        self.enableIntelligentRecommendations = enableIntelligentRecommendations
        self.preferredOrientationRawValue = preferredOrientation.rawValue
        self.updatedAt = updatedAt
    }

    var preferredOrientation: WallpaperOrientation {
        get {
            WallpaperOrientation(rawValue: preferredOrientationRawValue) ?? .portrait
        }
        set {
            preferredOrientationRawValue = newValue.rawValue
            updatedAt = .now
        }
    }
}
