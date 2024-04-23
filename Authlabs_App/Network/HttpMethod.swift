//
//  HttpMethod.swift
//  Authlabs_App
//
//  Created by Matthew on 4/17/24.
//

import Foundation

enum HttpMethod {
    case get
    case post
    case put
    case patch
    case delete
    
    var type: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        }
    }
}
