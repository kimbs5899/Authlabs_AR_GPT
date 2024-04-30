//
//  MarkerData+CoreDataProperties.swift
//  
//
//  Created by Matthew on 4/29/24.
//
//

import Foundation
import CoreData


extension MarkerData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MarkerData> {
        return NSFetchRequest<MarkerData>(entityName: "MarkerData")
    }

    @NSManaged public var data: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String

}

// MARK: - MarkerImage -> MarkerImageMO 변환
extension MarkerData {
    convenience init(markerImage: MarkerImage, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = markerImage.id
        self.name = markerImage.name
        self.data = markerImage.data.base64EncodedString()
    }
}

// MARK: - MarkerImageMO -> MarkerImage 변환
extension MarkerData {
    func toDomain() -> MarkerImage? {
        guard let encodedData = Data(base64Encoded: data) else { return nil }
        return .init(id: id, name: name, data: encodedData)
    }
}
