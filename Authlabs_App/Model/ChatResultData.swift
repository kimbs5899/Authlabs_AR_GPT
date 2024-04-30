//
//  ChatResultData.swift
//  Authlabs_App
//
//  Created by Matthew on 4/24/24.
//

import Foundation
import UIKit

struct ChatResultData: Hashable {
    let id: UUID = UUID()
    let baseImage: String
    let similarity: String
    let detailInfomation: String
    let keywords: [String]
    
    init(baseImage: String, similarity: String, detailInfomation: String, keywords: [String]) {
        self.baseImage = baseImage
        self.similarity = similarity
        self.detailInfomation = detailInfomation
        self.keywords = keywords
    }
}
