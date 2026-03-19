import Observation

@MainActor
@Observable
final class AppServices {
    let apiClient: WallpaperAPIClient
    let recommendationEngine: WallpaperRecommendationEngine
    let photoLibraryService: any WallpaperImageSaving

    init(
        apiClient: WallpaperAPIClient = WallpaperAPIClient(),
        recommendationEngine: WallpaperRecommendationEngine = WallpaperRecommendationEngine(),
        photoLibraryService: any WallpaperImageSaving = PhotoLibraryService()
    ) {
        self.apiClient = apiClient
        self.recommendationEngine = recommendationEngine
        self.photoLibraryService = photoLibraryService
    }
}
