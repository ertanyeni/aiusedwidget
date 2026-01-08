import WidgetKit
import SwiftUI
import Models

struct Provider: TimelineProvider {
    typealias Entry = AIUsageEntry
    
    func placeholder(in context: Context) -> AIUsageEntry {
        AIUsageEntry(date: Date(), summary: generateMockSummary())
    }

    func getSnapshot(in context: Context, completion: @escaping (AIUsageEntry) -> ()) {
        let entry = AIUsageEntry(date: Date(), summary: fetchUsageSummary())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let summary = fetchUsageSummary()
        
        // Her 15 dakikada bir güncelleme
        var entries: [AIUsageEntry] = []
        for minuteOffset in stride(from: 0, to: 240, by: 15) {
            if let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate) {
                let entry = AIUsageEntry(date: entryDate, summary: summary)
                entries.append(entry)
            }
        }

        let timeline = Timeline(entries: entries, policy: .after(Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!))
        completion(timeline)
    }
    
    private func fetchUsageSummary() -> AIUsageSummary {
        // Şimdilik mock data döndürüyoruz
        // Daha sonra gerçek servislerden veri çekilecek
        return generateMockSummary()
    }
    
    private func generateMockSummary() -> AIUsageSummary {
        let calendar = Calendar.current
        let tomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
        
        let services: [UsageData] = [
            UsageData(
                service: .openai,
                tokensUsed: 125000,
                tokensRemaining: 875000,
                dailyLimit: 1000000,
                resetDate: tomorrow,
                requestsToday: 45,
                averageResponseTime: 2.3
            ),
            UsageData(
                service: .claude,
                tokensUsed: 68000,
                tokensRemaining: 232000,
                dailyLimit: 300000,
                resetDate: tomorrow,
                requestsToday: 28,
                averageResponseTime: 3.1
            ),
            UsageData(
                service: .cursor,
                tokensUsed: 45000,
                tokensRemaining: 55000,
                dailyLimit: 100000,
                resetDate: tomorrow,
                requestsToday: 12,
                averageResponseTime: 1.8
            )
        ]
        
        return AIUsageSummary(services: services)
    }
}

struct AIUsageEntry: TimelineEntry {
    let date: Date
    let summary: AIUsageSummary
}
