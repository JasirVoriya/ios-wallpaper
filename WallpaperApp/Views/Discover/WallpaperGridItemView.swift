import SwiftUI

struct WallpaperGridItemView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let wallpaper: Wallpaper
    let isFavorite: Bool
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: wallpaper.thumbnailURL) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: thumbnailHeight)
                        .clipped()
                case .failure:
                    wallpaperPlaceholder
                case .empty:
                    wallpaperPlaceholder
                @unknown default:
                    wallpaperPlaceholder
                }
            }
            .frame(maxWidth: .infinity)
            .background(.quaternary)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isSelected ? Color.accentColor : .clear, lineWidth: 3)
            }
            .overlay(alignment: .topTrailing) {
                if isFavorite {
                    Image(systemName: "heart.fill")
                        .font(.headline)
                        .foregroundStyle(.white, .pink)
                        .padding(8)
                        .accessibilityHidden(true)
                }
            }

            Text(wallpaper.author)
                .font(.subheadline)
                .bold()
                .lineLimit(1)

            Text(wallpaper.orientation.localizedTitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("作者 \(wallpaper.author)，\(wallpaper.orientation.localizedTitle) 壁纸")
        .accessibilityHint("打开可查看大图并保存")
    }

    private var thumbnailHeight: CGFloat {
        horizontalSizeClass == .regular ? 280 : 220
    }

    private var wallpaperPlaceholder: some View {
        ZStack {
            LinearGradient(
                colors: [.teal.opacity(0.25), .indigo.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Image(systemName: "photo")
                .font(.title2)
                .foregroundStyle(.secondary)
        }
        .frame(height: thumbnailHeight)
    }
}
