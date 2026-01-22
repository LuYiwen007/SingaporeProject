//
//  ChatMessage.swift
//  Team Proj
//
//  Created by benny on 2026/1/22.
//

import Foundation

struct ChatMessage: Identifiable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date
    
    init(content: String, isUser: Bool) {
        self.id = UUID()
        self.content = content
        self.isUser = isUser
        self.timestamp = Date()
    }
}
