import XCTest
@testable import WallpaperAppMac

final class WallpaperMacScaffoldTests: XCTestCase {
    func testMacShellScaffoldDefaultsToDiscoverSection() {
        XCTAssertEqual(WallpaperMacSection.discover.title, "Discover")
    }
}
