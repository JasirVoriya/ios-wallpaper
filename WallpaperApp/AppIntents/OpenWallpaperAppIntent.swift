import AppIntents

struct OpenWallpaperAppIntent: AppIntent {
    static let title: LocalizedStringResource = "Open Wallpaper App"
    static let description = IntentDescription("Open the wallpaper library to browse and save wallpapers.")
    static let openAppWhenRun = true

    func perform() async throws -> some IntentResult & ProvidesDialog {
        .result(dialog: "Wallpaper 应用已打开")
    }
}
