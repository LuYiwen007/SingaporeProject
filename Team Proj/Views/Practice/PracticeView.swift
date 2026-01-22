//
//  PracticeView.swift
//  Team Proj
//
//  Created by benny on 2026/1/22.
//

import SwiftUI

struct PracticeView: View {
    @State private var isQuizActive = false
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var quizQuestions: [QuizQuestion] = []
    @State private var showingResults = false
    
    private let vocabularyDB = VocabularyDatabase.shared
    private let numberOfQuestions = 10
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !isQuizActive {
                    startView
                } else if showingResults {
                    resultsView
                } else {
                    quizView
                }
            }
            .navigationTitle("Practice Quiz")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var startView: some View {
        VStack(spacing: AppTheme.Spacing.extraLarge) {
            Spacer()
            
            Image(systemName: "pencil.and.list.clipboard")
                .font(.system(size: 100))
                .foregroundColor(AppTheme.Colors.primaryPurple)
            
            VStack(spacing: AppTheme.Spacing.medium) {
                Text("Ready to Practice?")
                    .font(AppTheme.Fonts.title1)
                
                Text("Test your vocabulary knowledge with a quick quiz!")
                    .font(AppTheme.Fonts.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: AppTheme.Spacing.small) {
                QuizInfoRow(icon: "questionmark.circle", text: "\(numberOfQuestions) questions")
                QuizInfoRow(icon: "clock", text: "No time limit")
                QuizInfoRow(icon: "star", text: "Improve your skills")
            }
            .padding(AppTheme.Spacing.large)
            .background(AppTheme.Colors.secondaryBackground)
            .cornerRadius(AppTheme.CornerRadius.large)
            
            Button(action: startQuiz) {
                HStack {
                    Text("Start Quiz")
                        .font(AppTheme.Fonts.headline)
                    Image(systemName: "arrow.right")
                }
                .frame(maxWidth: .infinity)
                .padding(AppTheme.Spacing.medium)
                .background(AppTheme.Colors.primaryPurple)
                .foregroundColor(.white)
                .cornerRadius(AppTheme.CornerRadius.medium)
            }
            .padding(.horizontal, AppTheme.Spacing.extraLarge)
            
            Spacer()
        }
        .padding(AppTheme.Spacing.medium)
    }
    
    private var quizView: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            // Progress Bar
            VStack(spacing: AppTheme.Spacing.small) {
                HStack {
                    Text("Question \(currentQuestionIndex + 1) of \(quizQuestions.count)")
                        .font(AppTheme.Fonts.subheadline)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                    
                    Spacer()
                    
                    Text("Score: \(score)")
                        .font(AppTheme.Fonts.subheadline)
                        .foregroundColor(AppTheme.Colors.primaryPurple)
                        .bold()
                }
                
                ProgressView(value: Double(currentQuestionIndex), total: Double(quizQuestions.count))
                    .tint(AppTheme.Colors.primaryPurple)
            }
            .padding(.horizontal, AppTheme.Spacing.medium)
            
            // Current Question
            if currentQuestionIndex < quizQuestions.count {
                QuizQuestionView(
                    question: quizQuestions[currentQuestionIndex],
                    onAnswerSelected: handleAnswer
                )
            }
        }
    }
    
    private var resultsView: some View {
        VStack(spacing: AppTheme.Spacing.extraLarge) {
            Spacer()
            
            VStack(spacing: AppTheme.Spacing.large) {
                Image(systemName: scoreIcon)
                    .font(.system(size: 100))
                    .foregroundColor(scoreColor)
                
                Text("Quiz Complete!")
                    .font(AppTheme.Fonts.title1)
                
                VStack(spacing: AppTheme.Spacing.small) {
                    Text("Your Score")
                        .font(AppTheme.Fonts.headline)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                    
                    Text("\(score) / \(quizQuestions.count)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(scoreColor)
                    
                    Text(scoreMessage)
                        .font(AppTheme.Fonts.body)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .padding(AppTheme.Spacing.large)
                .frame(maxWidth: .infinity)
                .background(scoreColor.opacity(0.1))
                .cornerRadius(AppTheme.CornerRadius.large)
            }
            
            VStack(spacing: AppTheme.Spacing.small) {
                Button(action: startQuiz) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Try Again")
                    }
                    .font(AppTheme.Fonts.headline)
                    .frame(maxWidth: .infinity)
                    .padding(AppTheme.Spacing.medium)
                    .background(AppTheme.Colors.primaryPurple)
                    .foregroundColor(.white)
                    .cornerRadius(AppTheme.CornerRadius.medium)
                }
                
                Button(action: resetQuiz) {
                    Text("Back to Start")
                        .font(AppTheme.Fonts.callout)
                        .foregroundColor(AppTheme.Colors.primaryPurple)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.extraLarge)
            
            Spacer()
        }
        .padding(AppTheme.Spacing.medium)
    }
    
    private var scoreIcon: String {
        let percentage = Double(score) / Double(quizQuestions.count)
        if percentage >= 0.9 { return "star.fill" }
        if percentage >= 0.7 { return "hand.thumbsup.fill" }
        return "face.smiling"
    }
    
    private var scoreColor: Color {
        let percentage = Double(score) / Double(quizQuestions.count)
        if percentage >= 0.9 { return Color.yellow }
        if percentage >= 0.7 { return AppTheme.Colors.correctGreen }
        return AppTheme.Colors.primaryBlue
    }
    
    private var scoreMessage: String {
        let percentage = Double(score) / Double(quizQuestions.count)
        if percentage >= 0.9 { return "Outstanding! You're a vocabulary master!" }
        if percentage >= 0.7 { return "Great job! Keep up the good work!" }
        if percentage >= 0.5 { return "Good effort! Practice makes perfect!" }
        return "Keep learning! You're making progress!"
    }
    
    private func startQuiz() {
        quizQuestions = generateQuizQuestions()
        currentQuestionIndex = 0
        score = 0
        isQuizActive = true
        showingResults = false
    }
    
    private func handleAnswer(_ answerIndex: Int) {
        if answerIndex == quizQuestions[currentQuestionIndex].correctAnswerIndex {
            score += 1
        }
        
        if currentQuestionIndex < quizQuestions.count - 1 {
            currentQuestionIndex += 1
        } else {
            showingResults = true
        }
    }
    
    private func resetQuiz() {
        isQuizActive = false
        showingResults = false
        currentQuestionIndex = 0
        score = 0
        quizQuestions = []
    }
    
    private func generateQuizQuestions() -> [QuizQuestion] {
        let shuffledWords = vocabularyDB.words.shuffled().prefix(numberOfQuestions)
        
        return shuffledWords.map { word in
            let questionType = Int.random(in: 0...2)
            
            switch questionType {
            case 0: // Definition question
                return createDefinitionQuestion(for: word)
            case 1: // Example question
                return createExampleQuestion(for: word)
            default: // Synonym question
                return createSynonymQuestion(for: word)
            }
        }
    }
    
    private func createDefinitionQuestion(for word: Word) -> QuizQuestion {
        let correctDefinition = word.definition
        var options = [correctDefinition]
        
        // Get 3 wrong definitions
        let otherWords = vocabularyDB.words.filter { $0.id != word.id }.shuffled()
        for otherWord in otherWords.prefix(3) {
            options.append(otherWord.definition)
        }
        
        options.shuffle()
        let correctIndex = options.firstIndex(of: correctDefinition) ?? 0
        
        return QuizQuestion(
            question: "What does '\(word.word)' mean?",
            options: options,
            correctAnswerIndex: correctIndex,
            word: word
        )
    }
    
    private func createExampleQuestion(for word: Word) -> QuizQuestion {
        let correctExample = word.examples.randomElement() ?? word.examples[0]
        var options = [correctExample]
        
        // Get 3 wrong examples
        let otherWords = vocabularyDB.words.filter { $0.id != word.id }.shuffled()
        for otherWord in otherWords.prefix(3) {
            if let example = otherWord.examples.randomElement() {
                options.append(example)
            }
        }
        
        options.shuffle()
        let correctIndex = options.firstIndex(of: correctExample) ?? 0
        
        return QuizQuestion(
            question: "Which sentence correctly uses '\(word.word)'?",
            options: options,
            correctAnswerIndex: correctIndex,
            word: word
        )
    }
    
    private func createSynonymQuestion(for word: Word) -> QuizQuestion {
        if word.synonyms.isEmpty {
            return createDefinitionQuestion(for: word)
        }
        
        let correctSynonym = word.synonyms.randomElement() ?? word.synonyms[0]
        var options = [correctSynonym]
        
        // Get 3 wrong synonyms
        let otherWords = vocabularyDB.words.filter { $0.id != word.id }.shuffled()
        for otherWord in otherWords.prefix(3) {
            if let synonym = otherWord.synonyms.randomElement() {
                options.append(synonym)
            } else {
                options.append(otherWord.word)
            }
        }
        
        options.shuffle()
        let correctIndex = options.firstIndex(of: correctSynonym) ?? 0
        
        return QuizQuestion(
            question: "Which word is a synonym for '\(word.word)'?",
            options: options,
            correctAnswerIndex: correctIndex,
            word: word
        )
    }
}

struct QuizInfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppTheme.Colors.primaryPurple)
                .frame(width: 24)
            
            Text(text)
                .font(AppTheme.Fonts.callout)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Spacer()
        }
    }
}

#Preview {
    PracticeView()
}
