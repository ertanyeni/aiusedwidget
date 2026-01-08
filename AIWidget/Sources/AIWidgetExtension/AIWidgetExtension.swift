import WidgetKit
import SwiftUI

@main
struct AIWidgetExtension: Widget {
    let kind: String = "AIWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetView(entry: entry)
        }
        .configurationDisplayName("AI Usage Widget")
        .description("Displays API usage for AI services.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
