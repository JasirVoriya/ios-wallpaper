import AppIntents

struct WallpaperAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenWallpaperAppIntent(),
            phrases: [
                "Open \(.applicationName)",
                "Browse wallpapers in \(.applicationName)"
            ],
            shortTitle: "Open Wallpaper",
            systemImageName: "sparkles.rectangle.stack"
        )
    }
}
