//
//  VocabularyDatabase.swift
//  Team Proj
//
//  Created by benny on 2026/1/22.
//
//  Note: This file is kept for data model compatibility but no longer contains hardcoded words.
//  All vocabulary learning is now handled by AI.

import Foundation

class VocabularyDatabase {
    static let shared = VocabularyDatabase()
    
    private init() {}
    
    // Empty word list - all vocabulary is now provided by AI
    let words: [Word] = []
}
