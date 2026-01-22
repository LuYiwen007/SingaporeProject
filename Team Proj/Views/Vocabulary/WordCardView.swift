//
//  WordCardView.swift
//  Team Proj
//
//  Created by benny on 2026/1/22.
//

import SwiftUI

struct WordCardView: View {
    let word: Word
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            HStack {
                Text(word.word.capitalized)
                    .font(AppTheme.Fonts.wordTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Spacer()
                
                Text(word.category.rawValue)
                    .categoryBadgeStyle(for: word.category)
            }
            
            Text(word.definition)
                .font(AppTheme.Fonts.definition)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding(AppTheme.Spacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

#Preview {
    WordCardView(word: Word(
        word: "learn",
        definition: "To gain knowledge or skill by studying, practicing, or being taught.",
        examples: ["I want to learn English."],
        synonyms: ["study", "acquire"],
        category: .verb
    ))
    .padding()
}
