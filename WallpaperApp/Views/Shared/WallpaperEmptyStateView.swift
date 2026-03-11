import SwiftUI

struct WallpaperEmptyStateView: View {
    let title: Text
    let message: Text
    let systemImage: String

    var body: some View {
        ContentUnavailableView {
            Label {
                title
            } icon: {
                Image(systemName: systemImage)
            }
        } description: {
            message
        }
        .padding()
    }
}
