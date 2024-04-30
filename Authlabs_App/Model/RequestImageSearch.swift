//
//  SearchImage.swift
//  Authlabs_App
//
//  Created by Matthew on 4/29/24.
//

import Foundation

struct RequestImageSearch: Codable {
    let meta: Meta
    let documents: [Document]
}

struct Document: Codable {
    let collection: String
    let thumbnailURL: String
    let imageURL: String
    let width: Int
    let height: Int
    let displaySiteName: String
    let docURL: String
    let datetime: String

    enum CodingKeys: String, CodingKey {
        case collection
        case thumbnailURL = "thumbnail_url"
        case imageURL = "image_url"
        case width
        case height
        case displaySiteName = "display_sitename"
        case docURL = "doc_url"
        case datetime
    }
}

struct Meta: Codable {
    let totalCount: Int
    let pageableCount: Int
    let isEnd: Bool
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
