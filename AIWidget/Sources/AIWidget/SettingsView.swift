import SwiftUI
import AppKit
import Models
import Services

struct SettingsView: View {
    @State private var claudeKey: String = ""
    @State private var cursorKey: String = ""
    @State private var openaiKey: String = ""
    @State private var showClaudeKey: Bool = false
    @State private var showCursorKey: Bool = false
    @State private var showOpenAIKey: Bool = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: Field?
    
    enum Field {
        case claude, cursor, openai
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("API Anahtarlarını Girin")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            
            Divider()
            
            // Content - Form kullan
            Form {
                // Claude API Key Section
                Section {
                    HStack {
                        if showClaudeKey {
                            TextField("sk-ant-...", text: $claudeKey)
                                .font(.system(.body, design: .monospaced))
                                .focused($focusedField, equals: .claude)
                                .onTapGesture {
                                    focusedField = .claude
                                }
                        } else {
                            SecureField("sk-ant-...", text: $claudeKey)
                                .font(.system(.body, design: .monospaced))
                                .focused($focusedField, equals: .claude)
                                .onTapGesture {
                                    focusedField = .claude
                                }
                        }
                        
                        Button(action: { showClaudeKey.toggle() }) {
                            Image(systemName: showClaudeKey ? "eye.slash" : "eye")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    Label("Claude API Key", systemImage: "sparkles")
                        .foregroundColor(.orange)
                } footer: {
                    Text("Anthropic Console'dan API anahtarınızı alabilirsiniz")
                }
                
                // Cursor API Key Section
                Section {
                    HStack {
                        if showCursorKey {
                            TextField("cursor_...", text: $cursorKey)
                                .font(.system(.body, design: .monospaced))
                                .focused($focusedField, equals: .cursor)
                                .onTapGesture {
                                    focusedField = .cursor
                                }
                        } else {
                            SecureField("cursor_...", text: $cursorKey)
                                .font(.system(.body, design: .monospaced))
                                .focused($focusedField, equals: .cursor)
                                .onTapGesture {
                                    focusedField = .cursor
                                }
                        }
                        
                        Button(action: { showCursorKey.toggle() }) {
                            Image(systemName: showCursorKey ? "eye.slash" : "eye")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    Label("Cursor API Key", systemImage: "cursorarrow.click")
                        .foregroundColor(.blue)
                } footer: {
                    Text("Cursor ayarlarından API anahtarınızı alabilirsiniz")
                }
                
                // OpenAI/ChatGPT API Key Section
                Section {
                    HStack {
                        if showOpenAIKey {
                            TextField("sk-...", text: $openaiKey)
                                .font(.system(.body, design: .monospaced))
                                .focused($focusedField, equals: .openai)
                                .onTapGesture {
                                    focusedField = .openai
                                }
                        } else {
                            SecureField("sk-...", text: $openaiKey)
                                .font(.system(.body, design: .monospaced))
                                .focused($focusedField, equals: .openai)
                                .onTapGesture {
                                    focusedField = .openai
                                }
                        }
                        
                        Button(action: { showOpenAIKey.toggle() }) {
                            Image(systemName: showOpenAIKey ? "eye.slash" : "eye")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    Label("ChatGPT/OpenAI API Key", systemImage: "brain.head.profile")
                        .foregroundColor(.green)
                } footer: {
                    Text("OpenAI Platform'dan API anahtarınızı alabilirsiniz")
                }
            }
            
            Divider()
            
            // Footer buttons
            HStack(spacing: 16) {
                Button("İptal") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                
                Spacer()
                
                Button("Kaydet") {
                    saveKeys()
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .frame(width: 600, height: 500)
        .onAppear {
            loadKeys()
            // Settings view açıldığında window'u aktif hale getir
            DispatchQueue.main.async {
                NSApplication.shared.activate(ignoringOtherApps: true)
                if let window = NSApplication.shared.windows.first(where: { $0.isSheet }) ?? NSApplication.shared.windows.first {
                    window.makeKeyAndOrderFront(nil)
                }
            }
        }
        .alert("Bilgi", isPresented: $showAlert) {
            Button("Tamam", role: .cancel) {
                if !alertMessage.contains("hata") {
                    dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func loadKeys() {
        claudeKey = APIKeyManager.shared.claudeAPIKey ?? ""
        cursorKey = APIKeyManager.shared.cursorAPIKey ?? ""
        openaiKey = APIKeyManager.shared.openaiAPIKey ?? ""
    }
    
    private func saveKeys() {
        APIKeyManager.shared.claudeAPIKey = claudeKey.isEmpty ? nil : claudeKey
        APIKeyManager.shared.cursorAPIKey = cursorKey.isEmpty ? nil : cursorKey
        APIKeyManager.shared.openaiAPIKey = openaiKey.isEmpty ? nil : openaiKey
        
        alertMessage = "API anahtarları başarıyla kaydedildi!"
        showAlert = true
    }
}
