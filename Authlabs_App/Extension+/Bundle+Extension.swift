//
//  Bundle+Extension.swift
//  Authlabs_App
//
//  Created by Matthew on 4/17/24.
//

import Foundation

extension Bundle {
    var chatApi: String {
        guard
            let file = self.path(forResource: "APIToken", ofType: "plist"),
            let resource = NSDictionary(contentsOfFile: file),
            let key = resource["API_Token"] as? String
        else {
            return ""
        }
        return key
    }
}
