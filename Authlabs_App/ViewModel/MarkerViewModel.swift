//
//  MarkerManager.swift
//  Authlabs_App
//
//  Created by Matthew on 4/29/24.
//

import CoreData

final class MarkerViewModel {
    static let shared = MarkerViewModel()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MarkerData")
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
    
    private init() {}
}

// MARK: - MarkerImageManageable 프로토콜 구현부
extension MarkerViewModel {
    func readMarkerImage(by id: UUID) -> MarkerData? {
        let fetchRequest: NSFetchRequest<MarkerData> = MarkerData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try persistentContainer.viewContext.fetch(fetchRequest)
                return results.first
            } catch {
                print("Failed to fetch MarkerImage:", error.localizedDescription)
                return nil
            }
    }
    
    func readAllMarkerImage() -> [MarkerImage] {
        do {
            let markerImage = try persistentContainer.viewContext.fetch(MarkerData.fetchRequest())
            let result: [MarkerImage] = markerImage.compactMap { $0.toDomain() }
            return result
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func updateMarkerImage(with markerImage: MarkerImage) {
        if let item = readMarkerImage(by: markerImage.id) {
            item.name = markerImage.name
            item.data = markerImage.data.base64EncodedString()
        }
    }
    
    func save() {
        guard persistentContainer.viewContext.hasChanges else { return }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save the context:", error.localizedDescription)
        }
    }
    
    func deleteMarkerImage(by id: UUID) {
        if let item = readMarkerImage(by: id) {
            persistentContainer.viewContext.delete(item)
        }
        save()
    }
}
