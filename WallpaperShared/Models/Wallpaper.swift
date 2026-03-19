import Foundation

struct Wallpaper: Codable, Hashable, Identifiable, Sendable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let sourcePageURL: URL
    let downloadURL: URL

    enum CodingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case sourcePageURL = "url"
        case downloadURL = "download_url"
    }

    var orientation: WallpaperOrientation {
        if width == height {
            return .square
        }
        return height > width ? .portrait : .landscape
    }

    var thumbnailURL: URL {
        URL(string: "https://picsum.photos/id/\(id)/500/900") ?? downloadURL
    }

    var previewURL: URL {
        URL(string: "https://picsum.photos/id/\(id)/1200/2200") ?? downloadURL
    }

    func matches(query: String) -> Bool {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard normalizedQuery.isEmpty == false else {
            return true
        }

        let lowercasedQuery = normalizedQuery.lowercased()
        return author.lowercased().contains(lowercasedQuery) || id.contains(lowercasedQuery)
    }
}
