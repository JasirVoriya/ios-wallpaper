import SwiftUI

struct DiscoverSelectionPlaceholderView: View {
    var body: some View {
        ContentUnavailableView {
            Label("选择一张壁纸", systemImage: "rectangle.stack.person.crop")
        } description: {
            Text("在左侧挑选一张壁纸，这里会显示大图预览和快捷操作。")
        }
    }
}
