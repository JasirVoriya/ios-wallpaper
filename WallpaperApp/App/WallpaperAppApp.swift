import SwiftData
import SwiftUI

@main
struct WallpaperAppApp: App {
    @State private var services = AppServices()

    private let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FavoriteWallpaper.self,
            DownloadRecord.self,
            UserPreferences.self
        ])

        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("ModelContainer 初始化失败: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(services)
        }
        .modelContainer(sharedModelContainer)
    }
}
