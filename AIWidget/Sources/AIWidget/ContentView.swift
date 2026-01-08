import SwiftUI
import Models

struct ContentView: View {
    @State private var summary: AIUsageSummary = generateMockSummary()
    @State private var showSettings = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Text("AI Usage Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        showSettings = true
                    }) {
                        Label("Ayarlar", systemImage: "gear")
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 20)
                
                // Toplam özet
                HStack(spacing: 20) {
                    StatCard(
                        title: "Total Used",
                        value: "\(formatNumber(summary.totalTokensUsed))",
                        subtitle: String(format: "%.1f%% of limit", summary.totalUsagePercentage),
                        color: .blue
                    )
                    StatCard(
                        title: "Remaining",
                        value: "\(formatNumber(summary.totalTokensRemaining))",
                        subtitle: "Available tokens",
                        color: .green
                    )
                    StatCard(
                        title: "Services",
                        value: "\(summary.services.count)",
                        subtitle: "Active providers",
                        color: .orange
                    )
                }
                
                // Chart görünümü
                VStack(alignment: .leading, spacing: 12) {
                    Text("Usage Overview")
                        .font(.headline)
                    
                    UsageChartView(summary: summary)
                        .frame(height: 200)
                }
                
                // Servis detayları
                VStack(alignment: .leading, spacing: 12) {
                    Text("Service Details")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        ForEach(summary.services) { service in
                            ServiceDetailCard(data: service)
                        }
                    }
                }
                
                // Widget ekleme talimatı
                VStack(spacing: 8) {
                    Text("Widget'ı eklemek için:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Notification Center > Widget'ları Düzenle > AI Usage Widget")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 20)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(minWidth: 800, minHeight: 600)
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

// MARK: - Helper Functions
private func formatNumber(_ number: Int) -> String {
    if number >= 1000000 {
        return String(format: "%.1fM", Double(number) / 1000000.0)
    } else if number >= 1000 {
        return String(format: "%.1fK", Double(number) / 1000.0)
    }
    return "\(number)"
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

// MARK: - Reused Views from Widget
struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

struct UsageChartView: View {
    let summary: AIUsageSummary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(summary.services) { service in
                    VStack(spacing: 4) {
                        GeometryReader { geometry in
                            VStack {
                                Spacer()
                                Rectangle()
                                    .fill(service.service.color)
                                    .frame(width: geometry.size.width * 0.7)
                                    .cornerRadius(4)
                                    .frame(height: geometry.size.height * CGFloat(service.usagePercentage / 100))
                            }
                        }
                        
                        Text(service.service.rawValue)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                        
                        Text("\(Int(service.usagePercentage))%")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(service.service.color)
                    }
                }
            }
            .frame(height: 200)
        }
    }
}

struct ServiceDetailCard: View {
    let data: UsageData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Image(systemName: data.service.icon)
                    .foregroundColor(data.service.color)
                    .font(.title3)
                
                Text(data.service.rawValue)
                    .font(.headline)
                
                Spacer()
                
                Text(String(format: "%.1f%%", data.usagePercentage))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(data.service.color)
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(data.service.color)
                        .frame(width: geometry.size.width * CGFloat(min(data.usagePercentage / 100, 1.0)), height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
            
            // Stats Grid - 2 rows
            VStack(spacing: 12) {
                // First Row
                HStack(spacing: 24) {
                    StatItem(label: "Used", value: "\(formatNumber(data.tokensUsed))", color: data.service.color)
                    
                    StatItem(label: "Remaining", value: "\(formatNumber(data.tokensRemaining))", color: .secondary)
                    
                    StatItem(label: "Limit", value: "\(formatNumber(data.dailyLimit))", color: .secondary)
                }
                
                // Second Row
                HStack(spacing: 24) {
                    StatItem(label: "Requests Today", value: "\(data.requestsToday)", color: .secondary)
                    
                    StatItem(label: "Avg Response", value: String(format: "%.1fs", data.averageResponseTime), color: .secondary)
                    
                    StatItem(label: "Reset in", value: data.formattedTimeUntilReset, color: .secondary)
                }
            }
        }
        .padding(16)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

struct StatItem: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
