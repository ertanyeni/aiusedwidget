import Foundation
import SwiftUI

public enum AIService: String, CaseIterable, Identifiable {
    case openai = "OpenAI"
    case claude = "Claude"
    case cursor = "Cursor"
    
    public var id: String { rawValue }
    
    public var color: Color {
        switch self {
        case .openai:
            return .green
        case .claude:
            return .orange
        case .cursor:
            return .blue
        }
    }
    
    public var icon: String {
        switch self {
        case .openai:
            return "brain.head.profile"
        case .claude:
            return "sparkles"
        case .cursor:
            return "cursorarrow.click"
        }
    }
}

public struct UsageData: Identifiable {
    public let service: AIService
    public let tokensUsed: Int
    public let tokensRemaining: Int
    public let dailyLimit: Int
    public let resetDate: Date
    public let requestsToday: Int
    public let averageResponseTime: TimeInterval // saniye cinsinden
    
    public init(service: AIService, tokensUsed: Int, tokensRemaining: Int, dailyLimit: Int, resetDate: Date, requestsToday: Int, averageResponseTime: TimeInterval) {
        self.service = service
        self.tokensUsed = tokensUsed
        self.tokensRemaining = tokensRemaining
        self.dailyLimit = dailyLimit
        self.resetDate = resetDate
        self.requestsToday = requestsToday
        self.averageResponseTime = averageResponseTime
    }
    
    public var usagePercentage: Double {
        guard dailyLimit > 0 else { return 0 }
        return Double(tokensUsed) / Double(dailyLimit) * 100
    }
    
    public var remainingPercentage: Double {
        guard dailyLimit > 0 else { return 100 }
        return Double(tokensRemaining) / Double(dailyLimit) * 100
    }
    
    public var timeUntilReset: TimeInterval {
        resetDate.timeIntervalSinceNow
    }
    
    public var formattedTimeUntilReset: String {
        let hours = Int(timeUntilReset) / 3600
        let minutes = (Int(timeUntilReset) % 3600) / 60
        if hours > 0 {
            return "\(hours)sa \(minutes)dk"
        }
        return "\(minutes)dk"
    }
    
    public var id: String { service.rawValue }
}

public struct AIUsageSummary {
    public let services: [UsageData]
    public let totalTokensUsed: Int
    public let totalTokensRemaining: Int
    public let totalDailyLimit: Int
    
    public init(services: [UsageData]) {
        self.services = services
        self.totalTokensUsed = services.reduce(0) { $0 + $1.tokensUsed }
        self.totalTokensRemaining = services.reduce(0) { $0 + $1.tokensRemaining }
        self.totalDailyLimit = services.reduce(0) { $0 + $1.dailyLimit }
    }
    
    public var totalUsagePercentage: Double {
        guard totalDailyLimit > 0 else { return 0 }
        return Double(totalTokensUsed) / Double(totalDailyLimit) * 100
    }
}
