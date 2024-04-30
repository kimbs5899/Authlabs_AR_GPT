//
//  MarkerProvider.swift
//  Authlabs_App
//
//  Created by Matthew on 4/30/24.
//

import Foundation
import ARKit

struct MarkerProvider {
    static var markerImageSet: [String: MarkerImage] = [:]
    
    static func loadMarkerImages() -> Set<ARReferenceImage> {
        let manager = MarkerViewModel.shared
        let referenceImages: Set<ARReferenceImage> = Set(manager.readAllMarkerImage().compactMap { markerImage in
            markerImageSet[markerImage.id.uuidString] = markerImage
            guard
                let image = UIImage(data: markerImage.data)?.cgImage
            else {
                return nil
            }
            let referenceImage = ARReferenceImage(image, orientation: .up, physicalWidth: 0.2)
            referenceImage.name = markerImage.id.uuidString
            return referenceImage
        })
        
        return referenceImages
    }
    
    static func getMetaData(by id: String) -> MarkerImage? {
        return markerImageSet[id]
    }
}
