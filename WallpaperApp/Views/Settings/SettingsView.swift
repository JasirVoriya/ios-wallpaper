import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @Query private var favorites: [FavoriteWallpaper]
    @Query private var downloads: [DownloadRecord]
    @State private var isRecommendationEnabled = true
    @State private var preferredOrientation: WallpaperOrientation = .portrait
    @State private var hasLoadedPreferences = false

    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                HStack {
                    settingsForm
                        .frame(maxWidth: 720)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            } else {
                settingsForm
            }
        }
        .navigationTitle("设置")
        .task {
            loadPreferencesIfNeeded()
        }
        .onChange(of: isRecommendationEnabled) { _, newValue in
            savePreferenceChange { preference in
                preference.enableIntelligentRecommendations = newValue
            }
        }
        .onChange(of: preferredOrientation) { _, newValue in
            savePreferenceChange { preference in
                preference.preferredOrientation = newValue
            }
        }
    }

    private var settingsForm: some View {
        Form {
            intelligenceSection
            preferenceSection
            statisticsSection
            privacySection
        }
    }

    private var intelligenceSection: some View {
        Section("智能推荐") {
            Toggle("启用本地智能推荐", isOn: $isRecommendationEnabled)
            Text("推荐逻辑完全在设备本地执行，不会上传你的收藏内容，符合最小化数据原则。")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    private var preferenceSection: some View {
        Section("偏好") {
            Picker("默认壁纸方向", selection: $preferredOrientation) {
                ForEach(WallpaperOrientation.allCases) { orientation in
                    Text(orientation.localizedTitle).tag(orientation)
                }
            }
        }
    }

    private var statisticsSection: some View {
        Section("数据") {
            LabeledContent("收藏数量", value: "\(favorites.count)")
            LabeledContent("下载次数", value: "\(downloads.count)")
        }
    }

    private var privacySection: some View {
        Section("Apple Intelligence 指南对齐") {
            Text("1. 只在用户明确授权后执行推荐。")
            Text("2. 保持解释性：推荐依据为“收藏作者、方向偏好、分辨率”。")
            Text("3. 提供关闭开关并保留基础功能。")
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
    }

    private func loadPreferencesIfNeeded() {
        guard hasLoadedPreferences == false else {
            return
        }

        let preference = PreferencesStore.ensureDefault(in: modelContext)
        isRecommendationEnabled = preference.enableIntelligentRecommendations
        preferredOrientation = preference.preferredOrientation
        hasLoadedPreferences = true
    }

    private func savePreferenceChange(_ update: (UserPreferences) -> Void) {
        guard hasLoadedPreferences else {
            return
        }

        let preference = PreferencesStore.ensureDefault(in: modelContext)
        update(preference)
        preference.updatedAt = .now

        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(
            for: [FavoriteWallpaper.self, DownloadRecord.self, UserPreferences.self],
            inMemory: true
        )
}
