//
//  Word.swift
//  Team Proj
//
//  Created by benny on 2026/1/22.
//

import Foundation

struct Word: Identifiable, Codable {
    let id: UUID
    let word: String
    let definition: String
    let examples: [String]
    let synonyms: [String]
    let category: WordCategory
    
    init(word: String, definition: String, examples: [String], synonyms: [String], category: WordCategory) {
        self.id = UUID()
        self.word = word
        self.definition = definition
        self.examples = examples
        self.synonyms = synonyms
        self.category = category
    }
}

enum WordCategory: String, CaseIterable, Codable {
    case verb = "Verb"
    case noun = "Noun"
    case adjective = "Adjective"
    case adverb = "Adverb"
    case phrase = "Phrase"
    
    var color: String {
        switch self {
        case .verb: return "blue"
        case .noun: return "green"
        case .adjective: return "purple"
        case .adverb: return "orange"
        case .phrase: return "pink"
        }
    }
}
