import Observation

@MainActor
@Observable
final class AppServices {
    let apiClient: WallpaperAPIClient
    let recommendationEngine: WallpaperRecommendationEngine
    let photoLibraryService: PhotoLibraryService

    init(
        apiClient: WallpaperAPIClient = WallpaperAPIClient(),
        recommendationEngine: WallpaperRecommendationEngine = WallpaperRecommendationEngine(),
        photoLibraryService: PhotoLibraryService = PhotoLibraryService()
    ) {
        self.apiClient = apiClient
        self.recommendationEngine = recommendationEngine
        self.photoLibraryService = photoLibraryService
    }
}
