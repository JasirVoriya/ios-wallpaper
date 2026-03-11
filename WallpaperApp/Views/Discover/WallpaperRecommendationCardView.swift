import SwiftUI

struct WallpaperRecommendationCardView: View {
    let recommendation: WallpaperRecommendation
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: recommendation.wallpaper.thumbnailURL) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure, .empty:
                    placeholder
                @unknown default:
                    placeholder
                }
            }
            .frame(height: 168)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            Label("为你推荐", systemImage: "sparkles")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.blue)

            Text(recommendation.headline)
                .font(.headline)
                .lineLimit(2)

            Text(recommendation.detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            Text(recommendation.wallpaper.author)
                .font(.caption)
                .foregroundStyle(.tertiary)
                .lineLimit(1)
        }
        .padding(14)
        .frame(width: 240, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(isSelected ? .blue : .clear, lineWidth: 3)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("推荐壁纸，作者 \(recommendation.wallpaper.author)。\(recommendation.headline)。\(recommendation.detail)")
    }

    private var placeholder: some View {
        ZStack {
            LinearGradient(
                colors: [.cyan.opacity(0.25), .blue.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Image(systemName: "photo")
                .font(.title2)
                .foregroundStyle(.secondary)
        }
    }
}
