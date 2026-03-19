import XCTest
@testable import WallpaperApp

final class WallpaperSharedScaffoldTests: XCTestCase {
    func testSharedScaffoldTrackIdentifierRemainsStable() {
        XCTAssertEqual(PlatformArchitectureScaffold.activeTrack, "002-multiplatform-architecture")
    }
}
