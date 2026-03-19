import Foundation

protocol WallpaperImageSaving: Sendable {
    func saveImageData(_ data: Data) async throws
}
