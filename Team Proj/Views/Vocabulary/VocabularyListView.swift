//
//  VocabularyListView.swift
//  Team Proj
//
//  Created by benny on 2026/1/22.
//

import SwiftUI

struct VocabularyListView: View {
    @State private var searchText = ""
    @State private var selectedCategory: WordCategory?
    @State private var selectedWord: Word?
    @State private var showingWordDetail = false
    
    private let vocabularyDB = VocabularyDatabase.shared
    
    var filteredWords: [Word] {
        var words = vocabularyDB.words
        
        // Filter by category
        if let category = selectedCategory {
            words = words.filter { $0.category == category }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            words = words.filter { word in
                word.word.lowercased().contains(searchText.lowercased()) ||
                word.definition.lowercased().contains(searchText.lowercased())
            }
        }
        
        return words.sorted { $0.word < $1.word }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppTheme.Spacing.small) {
                        CategoryFilterButton(
                            title: "All",
                            isSelected: selectedCategory == nil
                        ) {
                            selectedCategory = nil
                        }
                        
                        ForEach(WordCategory.allCases, id: \.self) { category in
                            CategoryFilterButton(
                                title: category.rawValue,
                                isSelected: selectedCategory == category,
                                category: category
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.medium)
                    .padding(.vertical, AppTheme.Spacing.small)
                }
                .background(AppTheme.Colors.secondaryBackground)
                
                Divider()
                
                // Words List
                if filteredWords.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppTheme.Spacing.medium) {
                            ForEach(filteredWords) { word in
                                Button {
                                    selectedWord = word
                                    showingWordDetail = true
                                } label: {
                                    WordCardView(word: word)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(AppTheme.Spacing.medium)
                    }
                }
            }
            .navigationTitle("Vocabulary")
            .searchable(text: $searchText, prompt: "Search words...")
            .sheet(isPresented: $showingWordDetail) {
                if let word = selectedWord {
                    WordDetailView(word: word)
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.Colors.tertiaryText)
            
            Text("No words found")
                .font(AppTheme.Fonts.title3)
                .foregroundColor(AppTheme.Colors.secondaryText)
            
            Text("Try adjusting your search or filters")
                .font(AppTheme.Fonts.body)
                .foregroundColor(AppTheme.Colors.tertiaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    var category: WordCategory?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Fonts.callout)
                .padding(.horizontal, AppTheme.Spacing.medium)
                .padding(.vertical, AppTheme.Spacing.small)
                .background(isSelected ? categoryColor : Color.clear)
                .foregroundColor(isSelected ? .white : AppTheme.Colors.primaryText)
                .cornerRadius(AppTheme.CornerRadius.large)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .stroke(categoryColor, lineWidth: isSelected ? 0 : 1)
                )
        }
    }
    
    private var categoryColor: Color {
        if let category = category {
            switch category {
            case .verb: return AppTheme.Colors.verbColor
            case .noun: return AppTheme.Colors.nounColor
            case .adjective: return AppTheme.Colors.adjectiveColor
            case .adverb: return AppTheme.Colors.adverbColor
            case .phrase: return AppTheme.Colors.phraseColor
            }
        }
        return AppTheme.Colors.primaryBlue
    }
}

#Preview {
    VocabularyListView()
}
