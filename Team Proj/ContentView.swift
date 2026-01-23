//
//  ContentView.swift
//  Team Proj
//
//  Created by benny on 2026/1/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ChatView()
                .tabItem {
                    Label("聊天", systemImage: "message.fill")
                }
            
            QuizView()
                .tabItem {
                    Label("答题", systemImage: "doc.text.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
