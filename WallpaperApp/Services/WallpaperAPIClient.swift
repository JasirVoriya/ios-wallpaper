import Foundation

actor WallpaperAPIClient {
    enum APIError: LocalizedError {
        case badResponse
        case invalidStatusCode(Int)

        var errorDescription: String? {
            switch self {
            case .badResponse:
                return NSLocalizedString("服务返回了无效响应。", comment: "API bad response")
            case let .invalidStatusCode(code):
                return String(
                    format: NSLocalizedString("服务暂时不可用（%@）。", comment: "API status code error"),
                    locale: Locale.current,
                    String(code)
                )
            }
        }
    }

    private let session: URLSession
    private let decoder = JSONDecoder()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchWallpapers(page: Int, pageSize: Int, query: String) async throws -> [Wallpaper] {
        var components = URLComponents(string: "https://picsum.photos/v2/list")
        components?.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "limit", value: String(pageSize))
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.badResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw APIError.invalidStatusCode(httpResponse.statusCode)
        }

        let wallpapers = try decoder.decode([Wallpaper].self, from: data)
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard normalizedQuery.isEmpty == false else {
            return wallpapers
        }

        return wallpapers.filter { $0.matches(query: normalizedQuery) }
    }

    func fetchImageData(from url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.badResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw APIError.invalidStatusCode(httpResponse.statusCode)
        }

        return data
    }
}
