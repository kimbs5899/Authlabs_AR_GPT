//
//  APIType.swift
//  Authlabs_App
//
//  Created by Matthew on 4/17/24.
//

import Foundation

enum APIType {
    case chatGPT
    
    var host: String? {
        switch self {
        case .chatGPT:
            return "api.openai.com"
        }
    }
    
    var header: [String:String]? {
        switch self {
        case .chatGPT:
            return ["Authorization": "Bearer \(Bundle.main.chatApi)"]
        }
    }
    
    var path: String {
        switch self {
        case .chatGPT:
            return "/v1/chat/completions"
        }
    }
}
