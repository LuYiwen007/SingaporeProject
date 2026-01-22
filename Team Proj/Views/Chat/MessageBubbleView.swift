//
//  MessageBubbleView.swift
//  Team Proj
//
//  Created by benny on 2026/1/22.
//

import SwiftUI

struct MessageBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(AppTheme.Fonts.body)
                    .foregroundColor(message.isUser ? AppTheme.Colors.userMessageText : AppTheme.Colors.aiMessageText)
                    .padding(AppTheme.Spacing.medium)
                    .background(message.isUser ? AppTheme.Colors.userMessageBackground : AppTheme.Colors.aiMessageBackground)
                    .cornerRadius(AppTheme.CornerRadius.large)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: message.isUser ? .trailing : .leading)
                
                Text(formatTime(message.timestamp))
                    .font(AppTheme.Fonts.caption2)
                    .foregroundColor(AppTheme.Colors.tertiaryText)
                    .padding(.horizontal, AppTheme.Spacing.tiny)
            }
            
            if !message.isUser {
                Spacer()
            }
        }
        .padding(.horizontal, AppTheme.Spacing.medium)
        .padding(.vertical, AppTheme.Spacing.tiny)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    VStack(spacing: 16) {
        MessageBubbleView(message: ChatMessage(content: "Hello! What does 'learn' mean?", isUser: true))
        MessageBubbleView(message: ChatMessage(content: "**Learn** (Verb)\n\nTo gain knowledge or skill by studying, practicing, or being taught.", isUser: false))
    }
    .padding()
}
