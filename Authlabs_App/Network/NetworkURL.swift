//
//  NetworkURL.swift
//  Authlabs_App
//
//  Created by Matthew on 4/17/24.
//

import Foundation

enum NetworkURL {
    static func makeURLRequest(type: APIType, chat: RequestChatDTO, httpMethod: HttpMethod = .get) -> URLRequest? {
        let urlComponents = makeURLComponents(type: type)
        
        guard
            let url = urlComponents.url,
            let body = try? JSONEncoder().encode(chat),
            let header = type.header
        else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.type
        request.allHTTPHeaderFields = header
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private static func makeURLComponents(type: APIType) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = type.host
        urlComponents.path = type.path
        return urlComponents
    }
    
    
}
