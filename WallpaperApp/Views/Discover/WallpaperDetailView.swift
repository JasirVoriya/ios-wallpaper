import SwiftData
import SwiftUI

struct WallpaperDetailView: View {
    let wallpaper: Wallpaper
    let showsNavigationChrome: Bool

    @Environment(\.modelContext) private var modelContext
    @Environment(AppServices.self) private var services

    @State private var isFavorite = false
    @State private var isSaving = false
    @State private var alertMessage = ""
    @State private var isShowingAlert = false

    var body: some View {
        Group {
            if showsNavigationChrome {
                detailBody
                    .navigationTitle("壁纸详情")
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                detailBody
            }
        }
        .task {
            await loadFavoriteStatus()
        }
        .alert("保存结果", isPresented: $isShowingAlert) {
        } message: {
            Text(alertMessage)
        }
    }

    init(wallpaper: Wallpaper, showsNavigationChrome: Bool = true) {
        self.wallpaper = wallpaper
        self.showsNavigationChrome = showsNavigationChrome
    }

    private var detailBody: some View {
        GeometryReader { geometry in
            ScrollView {
                if geometry.size.width >= 720 {
                    wideLayout(availableWidth: geometry.size.width)
                } else {
                    compactLayout
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }

    private var compactLayout: some View {
        VStack(alignment: .leading, spacing: 16) {
            wallpaperPreview(minHeight: 420)
            actionSection

            if isSaving {
                ProgressView("保存中")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 4)
            }

            detailsSection
            sourceSection
            setWallpaperTipsSection
        }
        .padding()
    }

    private func wideLayout(availableWidth: CGFloat) -> some View {
        HStack(alignment: .top, spacing: 24) {
            wallpaperPreview(minHeight: 560)
                .frame(maxWidth: min(availableWidth * 0.58, 640))

            VStack(alignment: .leading, spacing: 16) {
                actionSection

                if isSaving {
                    ProgressView("保存中")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                detailsSection
                sourceSection
                setWallpaperTipsSection
            }
            .frame(maxWidth: 360)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
    }

    private var actionSection: some View {
        HStack(spacing: 12) {
            Button(action: toggleFavorite) {
                Label(
                    isFavorite ? "已收藏" : "收藏",
                    systemImage: isFavorite ? "heart.fill" : "heart"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(isFavorite ? .pink : .blue)

            Button(action: saveWallpaperTask) {
                Label("保存到相册", systemImage: "square.and.arrow.down")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(isSaving)
        }
        .controlSize(.large)
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("信息")
                .font(.headline)

            LabeledContent("Picsum 编号", value: wallpaper.id)
            LabeledContent("作者", value: wallpaper.author)
            LabeledContent("方向", value: wallpaper.orientation.localizedTitle)
            LabeledContent("分辨率", value: "\(wallpaper.width) × \(wallpaper.height)")
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    private var setWallpaperTipsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("设置为壁纸")
                .font(.headline)
            Text("iOS 出于隐私和安全限制不允许应用自动更换系统壁纸。保存后可在“照片”中点击“设为墙纸”。")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var sourceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("来源与分享")
                .font(.headline)

            Link(destination: wallpaper.sourcePageURL) {
                Label("查看来源页面", systemImage: "safari")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            ShareLink(item: wallpaper.previewURL) {
                Label("分享预览图链接", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(.borderless)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func wallpaperPreview(minHeight: CGFloat) -> some View {
        AsyncImage(url: wallpaper.previewURL) { phase in
            switch phase {
            case let .success(image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            case .failure, .empty:
                detailPlaceholder(minHeight: minHeight)
            @unknown default:
                detailPlaceholder(minHeight: minHeight)
            }
        }
        .frame(maxWidth: .infinity, minHeight: minHeight)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func detailPlaceholder(minHeight: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.cyan.opacity(0.25), .blue.opacity(0.35)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            Image(systemName: "photo")
                .font(.system(size: 34))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: minHeight)
    }

    @MainActor
    private func loadFavoriteStatus() async {
        do {
            isFavorite = try FavoriteStore.contains(wallpaper, in: modelContext)
        } catch {
            isFavorite = false
        }
    }

    private func saveWallpaperTask() {
        Task { @MainActor in
            await saveWallpaper()
        }
    }

    private func toggleFavorite() {
        do {
            isFavorite = try FavoriteStore.toggle(wallpaper, in: modelContext)
        } catch {
            alertMessage = "收藏更新失败：\(error.localizedDescription)"
            isShowingAlert = true
        }
    }

    @MainActor
    private func saveWallpaper() async {
        isSaving = true
        defer { isSaving = false }

        do {
            let imageData = try await services.apiClient.fetchImageData(from: wallpaper.downloadURL)
            try await services.photoLibraryService.saveImageData(imageData)
            try DownloadHistoryStore.recordDownload(for: wallpaper, in: modelContext)
            alertMessage = "已保存到照片，你可以在系统相册中设置为墙纸。"
        } catch {
            alertMessage = "保存失败：\(error.localizedDescription)"
        }

        isShowingAlert = true
    }
}
