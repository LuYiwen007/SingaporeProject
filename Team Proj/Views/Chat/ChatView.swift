//
//  ChatView.swift
//  Team Proj
//
//  Created by benny on 2026/1/22.
//

import SwiftUI

struct ChatView: View {
    @State private var messages: [ChatMessage] = []
    @State private var inputText: String = ""
    @State private var isTyping: Bool = false
    @State private var errorMessage: String?
    @FocusState private var isInputFocused: Bool
    
    private let qwenAPI = QwenAPIService.shared
    private let vocabularyDB = VocabularyDatabase.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Messages ScrollView
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: AppTheme.Spacing.small) {
                            if messages.isEmpty {
                                welcomeView
                            }
                            
                            ForEach(messages) { message in
                                MessageBubbleView(message: message)
                                    .id(message.id)
                            }
                            
                            if isTyping {
                                HStack {
                                    TypingIndicatorView()
                                    Spacer()
                                }
                                .padding(.horizontal, AppTheme.Spacing.medium)
                                .id("typing")
                            }
                        }
                        .padding(.vertical, AppTheme.Spacing.small)
                    }
                    .onChange(of: messages.count) { _, _ in
                        scrollToBottom(proxy: proxy)
                    }
                    .onChange(of: isTyping) { _, _ in
                        scrollToBottom(proxy: proxy)
                    }
                }
                
                // Input Area
                VStack(spacing: 0) {
                    Divider()
                    
                    HStack(spacing: AppTheme.Spacing.medium) {
                        TextField("Ask anything about English...", text: $inputText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isInputFocused)
                            .disabled(isTyping)
                            .onSubmit {
                                sendMessage()
                            }
                        
                        Button(action: sendMessage) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(inputText.isEmpty ? AppTheme.Colors.tertiaryText : AppTheme.Colors.primaryBlue)
                        }
                        .disabled(inputText.isEmpty)
                    }
                    .padding(AppTheme.Spacing.medium)
                }
                .background(AppTheme.Colors.secondaryBackground)
            }
            .navigationTitle("AI Vocabulary Tutor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: clearChat) {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
    
    private var welcomeView: some View {
            VStack(spacing: AppTheme.Spacing.large) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 80))
                    .foregroundColor(AppTheme.Colors.primaryBlue)
                
                VStack(spacing: AppTheme.Spacing.small) {
                    Text("AI Vocabulary Tutor")
                        .font(AppTheme.Fonts.title2)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                        Text("Powered by Qwen AI")
                            .font(AppTheme.Fonts.caption)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }
                }
                
                Text("Ask me anything about English vocabulary!\nI'm a real AI assistant ready to help you learn.")
                    .font(AppTheme.Fonts.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                    SuggestionChip(text: "What does 'learn' mean?") {
                        inputText = "What does 'learn' mean?"
                        sendMessage()
                    }
                    SuggestionChip(text: "Give me examples of 'important'") {
                        inputText = "Give me examples of 'important'"
                        sendMessage()
                    }
                    SuggestionChip(text: "How can I improve my vocabulary?") {
                        inputText = "How can I improve my vocabulary?"
                        sendMessage()
                    }
                }
            }
            .padding(AppTheme.Spacing.extraLarge)
    }
    
    private func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(content: inputText, isUser: true)
        messages.append(userMessage)
        
        let query = inputText
        inputText = ""
        isInputFocused = false
        errorMessage = nil
        
        // Show typing indicator
        isTyping = true
        
        // Call Qwen AI API
        Task {
            do {
                let response = try await qwenAPI.sendMessage(query)
                
                await MainActor.run {
                    isTyping = false
                    let aiMessage = ChatMessage(content: response, isUser: false)
                    messages.append(aiMessage)
                }
            } catch {
                await MainActor.run {
                    isTyping = false
                    errorMessage = error.localizedDescription
                    let errorResponse = "Sorry, I encountered an error: \(error.localizedDescription)\n\nPlease check your internet connection and try again."
                    let aiMessage = ChatMessage(content: errorResponse, isUser: false)
                    messages.append(aiMessage)
                }
            }
        }
    }
    
    private func clearChat() {
        messages.removeAll()
        qwenAPI.resetSession() // 重置AI会话
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                if isTyping {
                    proxy.scrollTo("typing", anchor: .bottom)
                } else if let lastMessage = messages.last {
                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                }
            }
        }
    }
}

struct TypingIndicatorView: View {
    @State private var animationState = 0
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(AppTheme.Colors.secondaryText)
                    .frame(width: 8, height: 8)
                    .opacity(animationState == index ? 1.0 : 0.4)
            }
        }
        .padding(AppTheme.Spacing.medium)
        .background(AppTheme.Colors.aiMessageBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
            withAnimation {
                animationState = (animationState + 1) % 3
            }
        }
    }
}

struct SuggestionChip: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 14))
                Text(text)
                    .font(AppTheme.Fonts.callout)
            }
            .padding(.horizontal, AppTheme.Spacing.medium)
            .padding(.vertical, AppTheme.Spacing.small)
            .background(AppTheme.Colors.primaryBlue.opacity(0.1))
            .foregroundColor(AppTheme.Colors.primaryBlue)
            .cornerRadius(AppTheme.CornerRadius.large)
        }
    }
}

#Preview {
    ChatView()
}
