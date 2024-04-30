//
//  APIType.swift
//  Authlabs_App
//
//  Created by Matthew on 4/17/24.
//

import Foundation

enum APIType {
    case chatGPT
    case kakao(keyword: [String])
    case image(url: URL)
    
    var host: String? {
        switch self {
        case .chatGPT:
            return "api.openai.com"
        case .kakao:
            return "dapi.kakao.com"
        case .image(url: let url):
            return url.host
        }
    }
    
    var header: [String:String]? {
        switch self {
        case .chatGPT:
            return ["Authorization": "Bearer \(Bundle.main.chatApi)"]
        case .kakao:
            return ["Authorization": "KakaoAK \(Bundle.main.kakaoApi)"]
        case .image:
            return nil
        }
    }
    
    var queries: [URLQueryItem]? {
        switch self {
        case .chatGPT:
            return nil
        case .kakao(keyword: let keyword):
            return [
                URLQueryItem(name: "query", value: "\(keyword[0]) \(keyword[1]) \(keyword[2])"),
                URLQueryItem(name: "sort", value: "accuracy")
            ]
        case .image(let url):
            guard
                let urlComponents = URLComponents(
                    url: url,
                    resolvingAgainstBaseURL: false
                )
            else {
                return nil
            }
            return urlComponents.queryItems
        }
    }
    
    
    var path: String {
        switch self {
        case .chatGPT:
            return "/v1/chat/completions"
        case .kakao(keyword: let keyword):
            return "/v2/search/image"
        case .image(url: let url):
            return url.path
        }
    }
}
