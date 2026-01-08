import Foundation

public class APIKeyManager {
    public static let shared = APIKeyManager()
    
    private let userDefaults = UserDefaults.standard
    private let claudeKeyKey = "claude_api_key"
    private let cursorKeyKey = "cursor_api_key"
    private let openaiKeyKey = "openai_api_key"
    
    private init() {}
    
    // Claude API Key
    public var claudeAPIKey: String? {
        get {
            return userDefaults.string(forKey: claudeKeyKey)
        }
        set {
            if let key = newValue, !key.isEmpty {
                userDefaults.set(key, forKey: claudeKeyKey)
            } else {
                userDefaults.removeObject(forKey: claudeKeyKey)
            }
        }
    }
    
    // Cursor API Key
    public var cursorAPIKey: String? {
        get {
            return userDefaults.string(forKey: cursorKeyKey)
        }
        set {
            if let key = newValue, !key.isEmpty {
                userDefaults.set(key, forKey: cursorKeyKey)
            } else {
                userDefaults.removeObject(forKey: cursorKeyKey)
            }
        }
    }
    
    // OpenAI/ChatGPT API Key
    public var openaiAPIKey: String? {
        get {
            return userDefaults.string(forKey: openaiKeyKey)
        }
        set {
            if let key = newValue, !key.isEmpty {
                userDefaults.set(key, forKey: openaiKeyKey)
            } else {
                userDefaults.removeObject(forKey: openaiKeyKey)
            }
        }
    }
    
    public var hasAllKeys: Bool {
        return claudeAPIKey != nil && cursorAPIKey != nil && openaiAPIKey != nil
    }
}
