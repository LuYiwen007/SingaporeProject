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
    private let appId = "a08393d338c74e59a2fd2ae84f93b265"
    private var sessionId: String?
    
    private var apiEndpoint: String {
        return "https://dashscope.aliyuncs.com/api/v1/apps/\(appId)/completion"
    }
    
    private init() {}
    
    func sendMessage(_ message: String) async throws -> String {
        // 准备请求体（按照智能体应用API格式）
        var requestBody: [String: Any] = [
            "input": [
                "prompt": message
            ],
            "parameters": [
                "incremental_output": false
            ]
        ]
        
        // 如果有会话ID，携带历史对话
        if let sessionId = sessionId {
            if var input = requestBody["input"] as? [String: Any] {
                input["session_id"] = sessionId
                requestBody["input"] = input
            }
        }
        
        // 创建URL请求
        guard let url = URL(string: apiEndpoint) else {
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
        
        // 保存会话ID，用于后续对话
        if let output = json["output"] as? [String: Any],
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
