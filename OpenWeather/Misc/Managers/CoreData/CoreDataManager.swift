//
//  CoreDataManager.swift
//  OpenWeather
//
//  Created by andres paladines on 11/12/23.
//

import Foundation
import CoreData
import Combine

struct ApiKeyData {
    let uuid: String
    let name: String
    let customDescription: String
}

class CoreDataManager: CoreDataOperationsProtocol {

    typealias ItemType = [ApiKeyData]
    
    let context: NSManagedObjectContext
    
    required init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchSingleItemFromDatabase(uuid: String) throws -> ApiKeyEntity? {
        let fetchRequest: NSFetchRequest<ApiKeyEntity> = ApiKeyEntity.fetchRequest()
        let predicate = NSPredicate(format: "uuid == %@", uuid)
        fetchRequest.predicate = predicate
        let result = try context.fetch(fetchRequest).first
        return result
    }
    
    func fetchDataFromDatabase() throws -> [ApiKeyEntity] {
        let request: NSFetchRequest<ApiKeyEntity> = ApiKeyEntity.fetchRequest()
        let result = try context.fetch(request)
        return result
    }

    func saveDataIntoDatabase(item: ApiKeyData) throws {
        let noteEntity = ApiKeyEntity(context: context)
        noteEntity.uuid = item.uuid
        noteEntity.name = item.name
        noteEntity.customDescription = item.customDescription
        noteEntity.dateCreation = Date()
        noteEntity.dateUpdate = Date()
        
        do {
            try context.save()
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    func updateApiKeyEntity(with item: ApiKeyData) throws {
        guard let noteEntity = try fetchSingleItemFromDatabase(uuid: item.uuid) else {
            print("ApiKeyEntity with UUID: \(item.uuid) not found.")
            return
        }
        noteEntity.uuid = item.uuid
        noteEntity.name = item.name
        noteEntity.customDescription = item.customDescription
        noteEntity.dateUpdate = Date()
        try context.save()
    }
    
    func deleteEntity(with note: ApiKeyData) throws{
        guard let noteEntity = try fetchSingleItemFromDatabase(uuid: note.uuid) else {
            print("ApiKeyEntity with UUID: \(note.uuid) not found.")
            return
        }
        context.delete(noteEntity)
        try context.save()
//        print("Note with uuid: \(note.uuid), deleted!")
    }
        
    func clearData() async throws {
        try await context.perform {
            let results = try self.fetchDataFromDatabase()
            results.forEach { entity in
                autoreleasepool {
                    self.context.delete(entity)
                }
            }
            try self.context.save()
        }
    }
}
