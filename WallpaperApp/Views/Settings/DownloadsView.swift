import SwiftData
import SwiftUI

struct DownloadsView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \DownloadRecord.downloadedAt, order: .reverse)
    private var downloads: [DownloadRecord]

    @State private var isShowingClearConfirmation = false

    var body: some View {
        Group {
            if downloads.isEmpty {
                ContentUnavailableView {
                    Label("暂无下载记录", systemImage: "arrow.down.doc")
                } description: {
                    Text("保存过壁纸后，这里会显示最近下载记录。")
                }
            } else {
                downloadsList
            }
        }
        .navigationTitle("最近下载")
        .navigationDestination(for: Wallpaper.self) { wallpaper in
            WallpaperDetailView(wallpaper: wallpaper)
        }
        .toolbar {
            if downloads.isEmpty == false {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("清空", role: .destructive) {
                        isShowingClearConfirmation = true
                    }
                }
            }
        }
        .confirmationDialog("清空下载记录？", isPresented: $isShowingClearConfirmation) {
            Button("清空", role: .destructive, action: clearAll)
        } message: {
            Text("这不会删除已经保存到系统照片里的图片。")
        }
    }

    private var downloadsList: some View {
        List {
            ForEach(downloads) { download in
                NavigationLink(value: download.asWallpaper) {
                    HStack(spacing: 12) {
                        AsyncImage(url: download.asWallpaper.thumbnailURL) { phase in
                            switch phase {
                            case let .success(image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure, .empty:
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.quaternary)
                                    .overlay {
                                        Image(systemName: "photo")
                                            .foregroundStyle(.secondary)
                                    }
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 68, height: 96)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                        VStack(alignment: .leading, spacing: 6) {
                            Text(download.author)
                                .font(.headline)
                            Text(download.downloadedAt, format: .dateTime.month().day().hour().minute())
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("Picsum 编号 \(download.remoteID)")
                                .font(.footnote)
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .onDelete(perform: deleteDownloads)
        }
        .listStyle(.insetGrouped)
    }

    private func deleteDownloads(at offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(downloads[offset])
        }

        saveModelContext()
    }

    private func clearAll() {
        for download in downloads {
            modelContext.delete(download)
        }

        saveModelContext()
    }

    private func saveModelContext() {
        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
        }
    }
}
