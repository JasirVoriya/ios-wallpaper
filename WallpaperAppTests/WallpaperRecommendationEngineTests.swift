import XCTest
@testable import WallpaperApp

final class WallpaperRecommendationEngineTests: XCTestCase {
    func testRankingPrioritizesPreferredOrientationAndFavoriteAuthors() async {
        let engine = WallpaperRecommendationEngine()

        let portrait = Wallpaper(
            id: "1",
            author: "Alice",
            width: 1080,
            height: 1920,
            sourcePageURL: URL(string: "https://example.com/1")!,
            downloadURL: URL(string: "https://example.com/d1")!
        )

        let landscape = Wallpaper(
            id: "2",
            author: "Bob",
            width: 1920,
            height: 1080,
            sourcePageURL: URL(string: "https://example.com/2")!,
            downloadURL: URL(string: "https://example.com/d2")!
        )

        let ranked = await engine.rank(
            items: [landscape, portrait],
            favorites: [FavoriteSnapshot(remoteID: "99", author: "Alice", orientation: .portrait)],
            preferredOrientation: .portrait
        )

        XCTAssertEqual(ranked.first?.id, "1")
    }
}
