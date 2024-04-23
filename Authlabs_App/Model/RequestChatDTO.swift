//
//  RequestChatDTO.swift
//  Authlabs_App
//
//  Created by Matthew on 4/17/24.
//

import Foundation

// MARK: - RequestChatDTO
struct RequestChatDTO: Codable {
    let model: String = "gpt-4-turbo"
    let messages: [Message]
    let maxTokens: Int = 300

    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case maxTokens = "max_tokens"
    }
}

// MARK: - Message
struct Message: Codable {
    var role: String = "user"
    let content: [Content]
}

// MARK: - Content
struct Content: Codable {
    let type: String
    let text: String?
    let imageURL: ImageURL?

    enum CodingKeys: String, CodingKey {
        case type
        case text
        case imageURL = "image_url"
    }
}

// MARK: - ImageURL
struct ImageURL: Codable {
    let url: String
}

