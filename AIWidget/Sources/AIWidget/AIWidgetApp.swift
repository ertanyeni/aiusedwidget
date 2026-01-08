import SwiftUI
import AppKit

@main
struct AIWidgetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Terminal'den çalıştırıldığında window'u aktif hale getir
                    DispatchQueue.main.async {
                        NSApplication.shared.activate(ignoringOtherApps: true)
                        if let window = NSApplication.shared.windows.first {
                            window.makeKeyAndOrderFront(nil)
                            window.makeFirstResponder(window.contentView)
                        }
                    }
                }
        }
        .commands {
            // Window menüsünü ekle
            CommandGroup(replacing: .newItem) {}
        }
    }
}
