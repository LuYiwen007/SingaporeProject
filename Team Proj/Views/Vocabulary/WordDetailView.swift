//
//  WordDetailView.swift
//  Team Proj
//
//  Created by benny on 2026/1/22.
//

import SwiftUI

struct WordDetailView: View {
    let word: Word
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                    // Word Header
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                        HStack {
                            Text(word.word.capitalized)
                                .font(AppTheme.Fonts.largeTitle)
                                .foregroundColor(AppTheme.Colors.primaryText)
                            
                            Spacer()
                        }
                        
                        Text(word.category.rawValue)
                            .categoryBadgeStyle(for: word.category)
                    }
                    .padding(AppTheme.Spacing.large)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(
                            colors: [categoryColor(for: word.category).opacity(0.1), Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(AppTheme.CornerRadius.large)
                    
                    // Definition Section
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                        Label("Definition", systemImage: "book.fill")
                            .font(AppTheme.Fonts.headline)
                            .foregroundColor(AppTheme.Colors.primaryBlue)
                        
                        Text(word.definition)
                            .font(AppTheme.Fonts.body)
                            .foregroundColor(AppTheme.Colors.primaryText)
                            .padding(AppTheme.Spacing.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(AppTheme.Colors.secondaryBackground)
                            .cornerRadius(AppTheme.CornerRadius.medium)
                    }
                    
                    // Examples Section
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                        Label("Examples", systemImage: "quote.bubble.fill")
                            .font(AppTheme.Fonts.headline)
                            .foregroundColor(AppTheme.Colors.primaryBlue)
                        
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                            ForEach(Array(word.examples.enumerated()), id: \.offset) { index, example in
                                HStack(alignment: .top, spacing: AppTheme.Spacing.small) {
                                    Text("\(index + 1).")
                                        .font(AppTheme.Fonts.callout)
                                        .foregroundColor(AppTheme.Colors.primaryBlue)
                                        .bold()
                                    
                                    Text(example)
                                        .font(AppTheme.Fonts.callout)
                                        .foregroundColor(AppTheme.Colors.primaryText)
                                }
                                .padding(AppTheme.Spacing.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(AppTheme.Colors.secondaryBackground)
                                .cornerRadius(AppTheme.CornerRadius.medium)
                            }
                        }
                    }
                    
                    // Synonyms Section
                    if !word.synonyms.isEmpty {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                            Label("Synonyms", systemImage: "arrow.triangle.2.circlepath")
                                .font(AppTheme.Fonts.headline)
                                .foregroundColor(AppTheme.Colors.primaryBlue)
                            
                            FlowLayout(spacing: AppTheme.Spacing.small) {
                                ForEach(word.synonyms, id: \.self) { synonym in
                                    Text(synonym)
                                        .font(AppTheme.Fonts.callout)
                                        .padding(.horizontal, AppTheme.Spacing.medium)
                                        .padding(.vertical, AppTheme.Spacing.small)
                                        .background(AppTheme.Colors.primaryPurple.opacity(0.1))
                                        .foregroundColor(AppTheme.Colors.primaryPurple)
                                        .cornerRadius(AppTheme.CornerRadius.medium)
                                }
                            }
                        }
                    }
                }
                .padding(AppTheme.Spacing.medium)
            }
            .navigationTitle("Word Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func categoryColor(for category: WordCategory) -> Color {
        switch category {
        case .verb: return AppTheme.Colors.verbColor
        case .noun: return AppTheme.Colors.nounColor
        case .adjective: return AppTheme.Colors.adjectiveColor
        case .adverb: return AppTheme.Colors.adverbColor
        case .phrase: return AppTheme.Colors.phraseColor
        }
    }
}

// Flow Layout for wrapping synonyms
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var frames: [CGRect] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                frames.append(CGRect(x: currentX, y: currentY, width: size.width, height: size.height))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

#Preview {
    WordDetailView(word: Word(
        word: "learn",
        definition: "To gain knowledge or skill by studying, practicing, or being taught.",
        examples: ["I want to learn English.", "She learns quickly."],
        synonyms: ["study", "acquire", "master"],
        category: .verb
    ))
}
