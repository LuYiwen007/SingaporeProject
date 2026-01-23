//
//  QuizQuestion.swift
//  Team Proj
//
//  Created by benny on 2026/1/22.
//

import Foundation

struct QuizQuestion: Identifiable, Codable {
    let id: UUID
    let question: String      // 对应 JSON 中的 "题目"
    let optionA: String       // 对应 JSON 中的 "A"
    let optionB: String       // 对应 JSON 中的 "B"
    let optionC: String       // 对应 JSON 中的 "C"
    let optionD: String       // 对应 JSON 中的 "D"
    let correctAnswer: String // 对应 JSON 中的 "正确答案" (A/B/C/D)
    let explanation: String   // 对应 JSON 中的 "解析"
    
    // 计算属性：将选项转换为数组
    var options: [String] {
        return [optionA, optionB, optionC, optionD]
    }
    
    // 计算属性：获取正确答案的索引 (0-3)
    var correctAnswerIndex: Int {
        switch correctAnswer {
        case "A": return 0
        case "B": return 1
        case "C": return 2
        case "D": return 3
        default: return 0
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case question = "题目"
        case optionA = "A"
        case optionB = "B"
        case optionC = "C"
        case optionD = "D"
        case correctAnswer = "正确答案"
        case explanation = "解析"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.question = try container.decode(String.self, forKey: .question)
        self.optionA = try container.decode(String.self, forKey: .optionA)
        self.optionB = try container.decode(String.self, forKey: .optionB)
        self.optionC = try container.decode(String.self, forKey: .optionC)
        self.optionD = try container.decode(String.self, forKey: .optionD)
        self.correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        self.explanation = try container.decode(String.self, forKey: .explanation)
    }
    
    // 保留旧的初始化方法以兼容现有代码
    init(question: String, optionA: String, optionB: String, optionC: String, optionD: String, correctAnswer: String, explanation: String) {
        self.id = UUID()
        self.question = question
        self.optionA = optionA
        self.optionB = optionB
        self.optionC = optionC
        self.optionD = optionD
        self.correctAnswer = correctAnswer
        self.explanation = explanation
    }
}
