import Foundation

enum RootTab: String, CaseIterable, Hashable, Identifiable {
    case discover
    case favorites
    case settings

    var id: Self {
        self
    }

    var title: String {
        switch self {
        case .discover:
            NSLocalizedString("发现", comment: "Root tab title")
        case .favorites:
            NSLocalizedString("收藏", comment: "Root tab title")
        case .settings:
            NSLocalizedString("设置", comment: "Root tab title")
        }
    }

    var systemImage: String {
        switch self {
        case .discover:
            "sparkles.rectangle.stack"
        case .favorites:
            "heart.fill"
        case .settings:
            "gearshape"
        }
    }
}
