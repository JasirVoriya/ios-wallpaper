import XCTest
@testable import WallpaperApp

final class WallpaperiOSScaffoldTests: XCTestCase {
    func testCurrentiOSShellStillBuildsThroughLegacyTarget() {
        XCTAssertEqual(WallpaperiOSScaffold.shell, "iOS")
    }
}
