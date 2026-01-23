//
//  QuizView.swift
//  Team Proj
//
//  Created by benny on 2026/1/23.
//

import SwiftUI

struct QuizView: View {
    @State private var currentQuestions: [QuizQuestion] = []
    @State private var currentQuestionIndex: Int = 0
    @State private var selectedAnswer: String? = nil
    @State private var showExplanation: Bool = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var quizPrompt: String = ""
    @State private var showSettings: Bool = false
    @State private var quizCount: Int = 1
    @State private var difficulty: String = "中等"
    
    private let qwenAPI = QwenAPIService.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if currentQuestions.isEmpty {
                    // 初始页面：输入出题要求
                    setupView
                } else {
                    // 答题页面
                    quizContentView
                }
            }
            .navigationTitle("AI 智能出题")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !currentQuestions.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("重新出题") {
                            resetQuiz()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Setup View
    private var setupView: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.large) {
                // 顶部图标
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 80))
                    .foregroundColor(AppTheme.Colors.primaryBlue)
                    .padding(.top, AppTheme.Spacing.extraLarge)
                
                VStack(spacing: AppTheme.Spacing.small) {
                    Text("AI 智能出题")
                        .font(AppTheme.Fonts.title2)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                        Text("Powered by Qwen AI")
                            .font(AppTheme.Fonts.caption)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }
                }
                
                // 出题设置
                VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                    Text("出题设置")
                        .font(AppTheme.Fonts.headline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                    
                    // 题目数量
                    HStack {
                        Text("题目数量：")
                            .font(AppTheme.Fonts.body)
                        Picker("", selection: $quizCount) {
                            ForEach(1...5, id: \.self) { num in
                                Text("\(num) 题").tag(num)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    // 难度选择
                    HStack {
                        Text("难度：")
                            .font(AppTheme.Fonts.body)
                        Picker("", selection: $difficulty) {
                            Text("简单").tag("简单")
                            Text("中等").tag("中等")
                            Text("困难").tag("困难")
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // 输入框
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                        Text("出题要求（可选）：")
                            .font(AppTheme.Fonts.callout)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                        
                        TextField("例如：关于 practice 的题目", text: $quizPrompt)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, AppTheme.Spacing.small)
                    }
                }
                .padding(AppTheme.Spacing.large)
                .background(AppTheme.Colors.secondaryBackground)
                .cornerRadius(AppTheme.CornerRadius.large)
                
                // 快速选项
                VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                    Text("快速开始")
                        .font(AppTheme.Fonts.headline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                    
                    QuickStartButton(title: "随机词汇题", icon: "shuffle") {
                        generateQuiz(prompt: "")
                    }
                    
                    QuickStartButton(title: "高频词汇题", icon: "star.fill") {
                        generateQuiz(prompt: "请出关于高频词汇的题目")
                    }
                    
                    QuickStartButton(title: "近义词辨析", icon: "arrow.triangle.branch") {
                        generateQuiz(prompt: "请出近义词辨析的题目")
                    }
                }
                
                // 开始出题按钮
                Button(action: {
                    generateQuiz(prompt: quizPrompt)
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Label("开始答题", systemImage: "play.fill")
                            .font(AppTheme.Fonts.headline)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppTheme.Colors.primaryBlue)
                .foregroundColor(.white)
                .cornerRadius(AppTheme.CornerRadius.large)
                .disabled(isLoading)
                
                if let error = errorMessage {
                    Text(error)
                        .font(AppTheme.Fonts.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(AppTheme.Spacing.large)
        }
    }
    
    // MARK: - Quiz Content View
    private var quizContentView: some View {
        VStack(spacing: 0) {
            // 进度指示器
            if currentQuestions.count > 1 {
                HStack {
                    Text("第 \(currentQuestionIndex + 1) / \(currentQuestions.count) 题")
                        .font(AppTheme.Fonts.callout)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                    
                    Spacer()
                }
                .padding(AppTheme.Spacing.medium)
                .background(AppTheme.Colors.secondaryBackground)
            }
            
            ScrollView {
                VStack(spacing: AppTheme.Spacing.large) {
                    if let question = currentQuestions[safe: currentQuestionIndex] {
                        // 题目卡片
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                            Text("题目")
                                .font(AppTheme.Fonts.caption)
                                .foregroundColor(AppTheme.Colors.secondaryText)
                            
                            Text(question.question)
                                .font(AppTheme.Fonts.title3)
                                .foregroundColor(AppTheme.Colors.primaryText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppTheme.Spacing.large)
                        .background(AppTheme.Colors.secondaryBackground)
                        .cornerRadius(AppTheme.CornerRadius.large)
                        
                        // 选项
                        VStack(spacing: AppTheme.Spacing.medium) {
                            ForEach(Array(["A", "B", "C", "D"].enumerated()), id: \.offset) { index, letter in
                                OptionButton(
                                    letter: letter,
                                    text: question.options[index],
                                    isSelected: selectedAnswer == letter,
                                    isCorrect: showExplanation ? letter == question.correctAnswer : nil
                                ) {
                                    if !showExplanation {
                                        selectedAnswer = letter
                                    }
                                }
                            }
                        }
                        
                        // 提交/下一题按钮
                        if !showExplanation {
                            Button(action: submitAnswer) {
                                Text("提交答案")
                                    .font(AppTheme.Fonts.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(selectedAnswer != nil ? AppTheme.Colors.primaryBlue : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(AppTheme.CornerRadius.large)
                            }
                            .disabled(selectedAnswer == nil)
                        } else {
                            // 解析
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                                HStack {
                                    Image(systemName: selectedAnswer == question.correctAnswer ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(selectedAnswer == question.correctAnswer ? .green : .red)
                                    Text(selectedAnswer == question.correctAnswer ? "回答正确！" : "回答错误")
                                        .font(AppTheme.Fonts.headline)
                                        .foregroundColor(selectedAnswer == question.correctAnswer ? .green : .red)
                                }
                                
                                Divider()
                                    .padding(.vertical, AppTheme.Spacing.small)
                                
                                Text("解析")
                                    .font(AppTheme.Fonts.callout)
                                    .foregroundColor(AppTheme.Colors.secondaryText)
                                
                                Text(question.explanation)
                                    .font(AppTheme.Fonts.body)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                            }
                            .padding(AppTheme.Spacing.large)
                            .background(Color.blue.opacity(0.05))
                            .cornerRadius(AppTheme.CornerRadius.large)
                            
                            // 下一题按钮
                            Button(action: nextQuestion) {
                                Text(currentQuestionIndex < currentQuestions.count - 1 ? "下一题" : "完成")
                                    .font(AppTheme.Fonts.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(AppTheme.Colors.primaryBlue)
                                    .foregroundColor(.white)
                                    .cornerRadius(AppTheme.CornerRadius.large)
                            }
                        }
                    }
                }
                .padding(AppTheme.Spacing.large)
            }
        }
    }
    
    // MARK: - Helper Functions
    private func generateQuiz(prompt: String) {
        isLoading = true
        errorMessage = nil
        
        // 构建完整的 prompt
        var fullPrompt = "请生成\(quizCount)道\(difficulty)难度的英语词汇选择题"
        if !prompt.isEmpty {
            fullPrompt += "，要求：\(prompt)"
        }
        
        Task {
            do {
                let questions = try await qwenAPI.generateQuiz(prompt: fullPrompt)
                
                await MainActor.run {
                    isLoading = false
                    if questions.isEmpty {
                        errorMessage = "未能生成题目，请重试"
                    } else {
                        currentQuestions = questions
                        currentQuestionIndex = 0
                        selectedAnswer = nil
                        showExplanation = false
                    }
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "出题失败：\(error.localizedDescription)"
                }
            }
        }
    }
    
    private func submitAnswer() {
        withAnimation {
            showExplanation = true
        }
    }
    
    private func nextQuestion() {
        if currentQuestionIndex < currentQuestions.count - 1 {
            withAnimation {
                currentQuestionIndex += 1
                selectedAnswer = nil
                showExplanation = false
            }
        } else {
            // 完成所有题目
            resetQuiz()
        }
    }
    
    private func resetQuiz() {
        withAnimation {
            currentQuestions = []
            currentQuestionIndex = 0
            selectedAnswer = nil
            showExplanation = false
            quizPrompt = ""
            errorMessage = nil
        }
    }
}

// MARK: - Supporting Views
struct OptionButton: View {
    let letter: String
    let text: String
    let isSelected: Bool
    let isCorrect: Bool?
    let action: () -> Void
    
    var backgroundColor: Color {
        if let isCorrect = isCorrect {
            if isCorrect {
                return .green.opacity(0.2)
            } else if isSelected {
                return .red.opacity(0.2)
            }
        } else if isSelected {
            return AppTheme.Colors.primaryBlue.opacity(0.1)
        }
        return AppTheme.Colors.secondaryBackground
    }
    
    var borderColor: Color {
        if let isCorrect = isCorrect {
            return isCorrect ? .green : (isSelected ? .red : Color.gray.opacity(0.3))
        } else if isSelected {
            return AppTheme.Colors.primaryBlue
        }
        return Color.gray.opacity(0.3)
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.medium) {
                // 选项字母
                Text(letter)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(isSelected ? AppTheme.Colors.primaryBlue : Color.gray.opacity(0.6))
                    )
                
                // 选项内容
                Text(text)
                    .font(AppTheme.Fonts.body)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // 正确/错误标记
                if let isCorrect = isCorrect {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : (isSelected ? "xmark.circle.fill" : ""))
                        .foregroundColor(isCorrect ? .green : .red)
                        .font(.title3)
                }
            }
            .padding(AppTheme.Spacing.medium)
            .background(backgroundColor)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .stroke(borderColor, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct QuickStartButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(title)
                    .font(AppTheme.Fonts.body)
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.system(size: 14))
            }
            .padding(AppTheme.Spacing.medium)
            .background(AppTheme.Colors.secondaryBackground)
            .foregroundColor(AppTheme.Colors.primaryBlue)
            .cornerRadius(AppTheme.CornerRadius.medium)
        }
    }
}

// Safe array access
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    QuizView()
}
