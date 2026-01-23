//
//  QwenAPIService.swift
//  Team Proj
//
//  Created by benny on 2026/1/22.
//

import Foundation

class QwenAPIService {
    static let shared = QwenAPIService()
    
    // 百炼智能体应用配置
    private let apiKey = "sk-d0b2e8afcc584f0ab1bc74d5c541fa21"
    
    // 聊天智能体 App ID
    private let chatAppId = "a08393d338c74e59a2fd2ae84f93b265"
    
    // 出题智能体 App ID
    private let quizAppId = "d2f0226f214749dd8bc5cd4f66bcb3f1"
    
    private var sessionId: String?
    
    private func apiEndpoint(for appId: String) -> String {
        return "https://dashscope.aliyuncs.com/api/v1/apps/\(appId)/completion"
    }
    
    private init() {}
    
    // 发送聊天消息
    func sendMessage(_ message: String) async throws -> String {
        return try await sendRequest(message: message, appId: chatAppId, useSession: true)
    }
    
    // 生成题目（单题或多题）
    func generateQuiz(prompt: String) async throws -> [QuizQuestion] {
        let response = try await sendRequest(message: prompt, appId: quizAppId, useSession: false)
        
        // 清理可能的 markdown 代码块标记
        let cleanedResponse = response
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 尝试解析为数组
        if let data = cleanedResponse.data(using: .utf8) {
            // 首先尝试解析为数组（多题）
            if let questions = try? JSONDecoder().decode([QuizQuestion].self, from: data) {
                return questions
            }
            // 如果失败，尝试解析为单个对象
            else if let question = try? JSONDecoder().decode(QuizQuestion.self, from: data) {
                return [question]
            }
        }
        
        throw APIError.parsingError
    }
    
    // 通用请求方法
    private func sendRequest(message: String, appId: String, useSession: Bool) async throws -> String {
        // 准备请求体（按照智能体应用API格式）
        var requestBody: [String: Any] = [
            "input": [
                "prompt": message
            ],
            "parameters": [
                "incremental_output": false
            ]
        ]
        
        // 如果需要使用会话ID，携带历史对话
        if useSession, let sessionId = sessionId {
            if var input = requestBody["input"] as? [String: Any] {
                input["session_id"] = sessionId
                requestBody["input"] = input
            }
        }
        
        // 创建URL请求
        guard let url = URL(string: apiEndpoint(for: appId)) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        // 发送请求
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 检查响应状态
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        // 处理错误响应
        guard httpResponse.statusCode == 200 else {
            // 尝试解析错误信息
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let message = json["message"] as? String {
                throw APIError.apiError(message: message)
            }
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }
        
        // 解析成功响应
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let output = json["output"] as? [String: Any],
              let text = output["text"] as? String else {
            throw APIError.parsingError
        }
        
        // 保存会话ID，用于后续对话（仅聊天智能体）
        if useSession, let output = json["output"] as? [String: Any],
           let newSessionId = output["session_id"] as? String {
            self.sessionId = newSessionId
        }
        
        return text
    }
    
    // 重置会话（开始新对话）
    func resetSession() {
        sessionId = nil
    }
    
    enum APIError: LocalizedError {
        case invalidURL
        case invalidResponse
        case httpError(statusCode: Int)
        case parsingError
        case apiError(message: String)
        case networkError(Error)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid API URL"
            case .invalidResponse:
                return "Invalid response from server"
            case .httpError(let statusCode):
                return "HTTP Error: \(statusCode)"
            case .parsingError:
                return "Failed to parse response"
            case .apiError(let message):
                return "API Error: \(message)"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            }
        }
    }
}
