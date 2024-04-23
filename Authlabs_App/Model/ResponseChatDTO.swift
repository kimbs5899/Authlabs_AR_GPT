//
//  ResponseChatDTO.swift
//  Authlabs_App
//
//  Created by Matthew on 4/20/24.
//

import Foundation

// MARK: - ResponseChatDTO
struct ResponseChatDTO: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
    let usage: Usage
    let systemFingerprint: String

    enum CodingKeys: String, CodingKey {
        case id
        case object
        case created
        case model
        case choices
        case usage
        case systemFingerprint = "system_fingerprint"
    }
}

// MARK: - Choice
struct Choice: Codable {
    let index: Int
    let message: ResponseMessage
    let logprobs: JSONNull?
    let finishReason: String

    enum CodingKeys: String, CodingKey {
        case index
        case message
        case logprobs
        case finishReason = "finish_reason"
    }
}

// MARK: - Message
struct ResponseMessage: Codable {
    let role: String
    let content: String
}

// MARK: - Usage
struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

