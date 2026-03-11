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
            "发现"
        case .favorites:
            "收藏"
        case .settings:
            "设置"
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
