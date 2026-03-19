import Foundation
import Photos

struct PhotoLibraryService: WallpaperImageSaving, Sendable {
    enum SaveError: LocalizedError {
        case permissionDenied
        case unknown

        var errorDescription: String? {
            switch self {
            case .permissionDenied:
                return NSLocalizedString(
                    "没有照片库写入权限，请在系统设置中允许“添加照片”。",
                    comment: "Photo library permission denied"
                )
            case .unknown:
                return NSLocalizedString("保存失败，请稍后重试。", comment: "Photo library save failed")
            }
        }
    }

    func saveImageData(_ data: Data) async throws {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        let isAuthorized: Bool

        switch status {
        case .authorized, .limited:
            isAuthorized = true
        case .notDetermined:
            isAuthorized = await requestAuthorization()
        case .restricted, .denied:
            isAuthorized = false
        @unknown default:
            isAuthorized = false
        }

        guard isAuthorized else {
            throw SaveError.permissionDenied
        }

        try await performChanges(imageData: data)
    }

    private func requestAuthorization() async -> Bool {
        await withCheckedContinuation { continuation in
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                continuation.resume(returning: status == .authorized || status == .limited)
            }
        }
    }

    private func performChanges(imageData: Data) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, any Error>) in
            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: imageData, options: nil)
            } completionHandler: { success, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                guard success else {
                    continuation.resume(throwing: SaveError.unknown)
                    return
                }

                continuation.resume(returning: ())
            }
        }
    }
}
