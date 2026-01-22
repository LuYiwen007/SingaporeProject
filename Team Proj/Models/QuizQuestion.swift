//
//  QuizQuestion.swift
//  Team Proj
//
//  Created by benny on 2026/1/22.
//

import Foundation

struct QuizQuestion: Identifiable {
    let id: UUID
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let word: Word
    
    init(question: String, options: [String], correctAnswerIndex: Int, word: Word) {
        self.id = UUID()
        self.question = question
        self.options = options
        self.correctAnswerIndex = correctAnswerIndex
        self.word = word
    }
}
