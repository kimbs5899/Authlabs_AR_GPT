//
//  MarkerImage.swift
//  Authlabs_App
//
//  Created by Matthew on 4/29/24.
//

import Foundation

struct MarkerImage {
    let id: UUID
    var name: String
    var data: Data
    
    init(
        id: UUID,
        name: String,
        data: Data
    ) {
        self.id = id
        self.name = name
        self.data = data
    }
    
    mutating func update(name: String, data: Data) {
        self.name = name
        self.data = data
    }
}
