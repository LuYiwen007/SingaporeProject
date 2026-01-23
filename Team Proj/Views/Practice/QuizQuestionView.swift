//
//  QuizQuestionView.swift
//  Team Proj
//
//  Created by benny on 2026/1/22.
//

import SwiftUI

struct QuizQuestionView: View {
    let question: QuizQuestion
    let onAnswerSelected: (Int) -> Void
    @State private var selectedAnswer: Int?
    @State private var showingResult = false
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            // Question
            VStack(spacing: AppTheme.Spacing.medium) {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(AppTheme.Colors.primaryBlue)
                
                Text(question.question)
                    .font(AppTheme.Fonts.title3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.large)
            }
            .padding(AppTheme.Spacing.large)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [AppTheme.Colors.primaryBlue.opacity(0.1), Color.clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(AppTheme.CornerRadius.large)
            
            // Options
            VStack(spacing: AppTheme.Spacing.medium) {
                ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                    QuizOptionButton(
                        option: option,
                        index: index,
                        isSelected: selectedAnswer == index,
                        isCorrect: index == question.correctAnswerIndex,
                        showingResult: showingResult
                    ) {
                        selectAnswer(index)
                    }
                }
            }
            
            if showingResult {
                resultView
            }
            
            Spacer()
        }
        .padding(AppTheme.Spacing.medium)
    }
    
    private var resultView: some View {
        VStack(spacing: AppTheme.Spacing.small) {
            if selectedAnswer == question.correctAnswerIndex {
                Label("Correct! Well done!", systemImage: "checkmark.circle.fill")
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.correctGreen)
            } else {
                Label("Not quite right. Keep practicing!", systemImage: "xmark.circle.fill")
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.incorrectRed)
            }
        }
        .padding(AppTheme.Spacing.medium)
        .frame(maxWidth: .infinity)
        .background(
            (selectedAnswer == question.correctAnswerIndex ?
             AppTheme.Colors.correctGreen : AppTheme.Colors.incorrectRed)
            .opacity(0.1)
        )
        .cornerRadius(AppTheme.CornerRadius.medium)
    }
    
    private func selectAnswer(_ index: Int) {
        guard selectedAnswer == nil else { return }
        
        selectedAnswer = index
        showingResult = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            onAnswerSelected(index)
        }
    }
}

struct QuizOptionButton: View {
    let option: String
    let index: Int
    let isSelected: Bool
    let isCorrect: Bool
    let showingResult: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(optionLabel(for: index))
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(labelBackgroundColor)
                    .cornerRadius(AppTheme.CornerRadius.small)
                
                Text(option)
                    .font(AppTheme.Fonts.body)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if showingResult && isSelected {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isCorrect ? AppTheme.Colors.correctGreen : AppTheme.Colors.incorrectRed)
                }
            }
            .padding(AppTheme.Spacing.medium)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .stroke(borderColor, lineWidth: 2)
            )
        }
        .disabled(showingResult)
    }
    
    private var backgroundColor: Color {
        if showingResult && isSelected {
            return isCorrect ?
                AppTheme.Colors.correctGreen.opacity(0.1) :
                AppTheme.Colors.incorrectRed.opacity(0.1)
        } else if isSelected {
            return AppTheme.Colors.primaryBlue.opacity(0.1)
        }
        return AppTheme.Colors.secondaryBackground
    }
    
    private var borderColor: Color {
        if showingResult && isSelected {
            return isCorrect ? AppTheme.Colors.correctGreen : AppTheme.Colors.incorrectRed
        } else if isSelected {
            return AppTheme.Colors.primaryBlue
        }
        return Color.clear
    }
    
    private var textColor: Color {
        if showingResult && isSelected {
            return isCorrect ? AppTheme.Colors.correctGreen : AppTheme.Colors.incorrectRed
        }
        return AppTheme.Colors.primaryText
    }
    
    private var labelBackgroundColor: Color {
        if showingResult && isSelected {
            return isCorrect ? AppTheme.Colors.correctGreen : AppTheme.Colors.incorrectRed
        }
        return AppTheme.Colors.primaryBlue
    }
    
    private func optionLabel(for index: Int) -> String {
        switch index {
        case 0: return "A"
        case 1: return "B"
        case 2: return "C"
        case 3: return "D"
        default: return "\(index + 1)"
        }
    }
}

#Preview {
    QuizQuestionView(
        question: QuizQuestion(
            question: "What does 'learn' mean?",
            optionA: "To gain knowledge",
            optionB: "To forget things",
            optionC: "To teach others",
            optionD: "To play games",
            correctAnswer: "A",
            explanation: "'learn' means to gain knowledge or skill by studying, practicing, or being taught."
        ),
        onAnswerSelected: { _ in }
    )
}
