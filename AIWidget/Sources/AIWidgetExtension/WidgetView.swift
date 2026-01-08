import SwiftUI
import WidgetKit

struct WidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}
