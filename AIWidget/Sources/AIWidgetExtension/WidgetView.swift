import SwiftUI
import WidgetKit
import Models

struct WidgetView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(summary: entry.summary)
        case .systemMedium:
            MediumWidgetView(summary: entry.summary)
        case .systemLarge:
            LargeWidgetView(summary: entry.summary)
        default:
            MediumWidgetView(summary: entry.summary)
        }
    }
}

// MARK: - Small Widget
struct SmallWidgetView: View {
    let summary: AIUsageSummary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("AI Usage")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            // Toplam kullanım
            VStack(alignment: .leading, spacing: 4) {
                Text("Total Tokens")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("\(summary.totalTokensUsed, specifier: "%.0f")")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("/ \(summary.totalTokensRemaining + summary.totalTokensUsed)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 6)
                            .cornerRadius(3)
                        
                        Rectangle()
                            .fill(progressColor(for: summary.totalUsagePercentage))
                            .frame(width: geometry.size.width * CGFloat(min(summary.totalUsagePercentage / 100, 1.0)), height: 6)
                            .cornerRadius(3)
                    }
                }
                .frame(height: 6)
                
                Text("\(summary.totalUsagePercentage, specifier: "%.1f")% used")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Her servis için kısa özet
            VStack(alignment: .leading, spacing: 6) {
                ForEach(summary.services.prefix(2)) { service in
                    ServiceMiniRow(data: service)
                }
            }
        }
        .padding()
    }
}

// MARK: - Medium Widget
struct MediumWidgetView: View {
    let summary: AIUsageSummary
    
    var body: some View {
        HStack(spacing: 16) {
            // Sol taraf - Chart/Özet
            VStack(alignment: .leading, spacing: 12) {
                Text("AI Usage Summary")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                // Chart görünümü
                UsageChartView(summary: summary)
                
                // Toplam istatistikler
                HStack(spacing: 16) {
                    StatBox(title: "Total Used", value: "\(summary.totalTokensUsed)", unit: "tokens")
                    StatBox(title: "Remaining", value: "\(summary.totalTokensRemaining)", unit: "tokens")
                }
            }
            
            Divider()
            
            // Sağ taraf - Servisler listesi
            VStack(alignment: .leading, spacing: 10) {
                Text("Services")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                ForEach(summary.services) { service in
                    ServiceRow(data: service)
                }
                
                Spacer()
            }
        }
        .padding()
    }
}

// MARK: - Large Widget
struct LargeWidgetView: View {
    let summary: AIUsageSummary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("AI Usage Dashboard")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Toplam özet kartı
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
            
            // Detaylı chart
            UsageChartView(summary: summary)
                .frame(height: 200)
            
            // Her servis için detaylı kart
            VStack(alignment: .leading, spacing: 12) {
                Text("Service Details")
                    .font(.headline)
                
                ForEach(summary.services) { service in
                    ServiceDetailCard(data: service)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Supporting Views
struct ServiceMiniRow: View {
    let data: UsageData
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(data.service.color)
                .frame(width: 8, height: 8)
            
            Text(data.service.rawValue)
                .font(.caption)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("\(Int(data.usagePercentage))%")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

struct ServiceRow: View {
    let data: UsageData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: data.service.icon)
                    .foregroundColor(data.service.color)
                    .font(.caption)
                
                Text(data.service.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
            }
            
            HStack {
                Text("\(formatNumber(data.tokensUsed))")
                    .font(.caption)
                    .foregroundColor(.primary)
                Text("/")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(formatNumber(data.tokensRemaining))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 4)
                        .cornerRadius(2)
                    
                    Rectangle()
                        .fill(data.service.color)
                        .frame(width: geometry.size.width * CGFloat(min(data.usagePercentage / 100, 1.0)), height: 4)
                        .cornerRadius(2)
                }
            }
            .frame(height: 4)
        }
    }
}

struct ServiceDetailCard: View {
    let data: UsageData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: data.service.icon)
                    .foregroundColor(data.service.color)
                    .font(.caption)
                
                Text(data.service.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(String(format: "%.1f%%", data.usagePercentage))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(data.service.color)
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(data.service.color)
                        .frame(width: geometry.size.width * CGFloat(min(data.usagePercentage / 100, 1.0)), height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(height: 6)
            
            // Stats - Compact layout for widget
            VStack(spacing: 8) {
                HStack(spacing: 16) {
                    WidgetStatItem(label: "Used", value: "\(formatNumber(data.tokensUsed))")
                    WidgetStatItem(label: "Remaining", value: "\(formatNumber(data.tokensRemaining))")
                }
                
                HStack(spacing: 16) {
                    WidgetStatItem(label: "Limit", value: "\(formatNumber(data.dailyLimit))")
                    WidgetStatItem(label: "Reset", value: data.formattedTimeUntilReset)
                }
            }
        }
        .padding(10)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}

struct WidgetStatItem: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct UsageChartView: View {
    let summary: AIUsageSummary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Bar chart görünümü
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
                    }
                }
            }
            .frame(height: 100)
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
            Text(unit)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

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

// MARK: - Helper Functions
private func formatNumber(_ number: Int) -> String {
    if number >= 1000000 {
        return String(format: "%.1fM", Double(number) / 1000000.0)
    } else if number >= 1000 {
        return String(format: "%.1fK", Double(number) / 1000.0)
    }
    return "\(number)"
}

private func progressColor(for percentage: Double) -> Color {
    if percentage >= 90 {
        return .red
    } else if percentage >= 70 {
        return .orange
    } else {
        return .green
    }
}

