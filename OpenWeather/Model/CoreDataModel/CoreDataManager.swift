//
//  CoreDataManager.swift
//  OpenWeather
//
//  Created by andres paladines on 11/12/23.
//

import Foundation
import CoreData
import Combine

struct ApiKeyData: Identifiable {
    let uuid: String
    let name: String
    let customDescription: String
    
    init(uuid: String, name: String, customDescription: String) {
        self.uuid = uuid
        self.name = name
        self.customDescription = customDescription
    }
    
    init(from entity: ApiKeyEntity) {
        self.uuid = entity.uuid ?? UUID().uuidString
        self.name = entity.name ?? "No name registered".localized()
        self.customDescription = entity.customDescription ?? "No description registered".localized()
    }
    
    var id: String {
        uuid
    }
}

class ApiKeyCoreDataManager: CoreDataOperationsProtocol {
    
    typealias ItemType = ApiKeyData
    typealias ItemEntityType = ApiKeyEntity
    
    let context: NSManagedObjectContext
    
    required init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchSingleItemFromDatabase(uuid: String) -> AnyPublisher<ItemEntityType, Error> {
        let fetchRequest: NSFetchRequest<ItemEntityType> = ItemEntityType.fetchRequest()
        let predicate = NSPredicate(format: "uuid == %@", uuid)
        fetchRequest.predicate = predicate
        
        return Future { [weak self] promise in
            do {
                let result = try self?.context.fetch(fetchRequest).first
                if let result_ = result {
                    promise(.success(result_))
                }else {
                    promise(.failure(NSError(domain: String(reflecting: ItemEntityType.self), code: 404, userInfo: [NSLocalizedDescriptionKey: "No data found".localized()])))
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchDataFromDatabase() -> AnyPublisher<[ItemEntityType], Error> {
        let request: NSFetchRequest<ItemEntityType> = ItemEntityType.fetchRequest()
        
        return Future { [weak self] promise in
            do {
                let result = try self?.context.fetch(request)
                promise(.success(result ?? []))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func saveDataIntoDatabase(item: ItemType) -> AnyPublisher<Bool, Error> {
        let noteEntity = ItemEntityType(context: context)
        noteEntity.uuid = item.uuid
        noteEntity.name = item.name
        noteEntity.customDescription = item.customDescription
        noteEntity.dateCreation = Date()
        noteEntity.dateUpdate = Date()
        
        return Future { [weak self] promise in
            do {
                try self?.context.save()
                promise(.success(true))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateApiKeyEntity(with item: ItemType) -> AnyPublisher<Bool, Error> {
        return fetchSingleItemFromDatabase(uuid: item.uuid)
            .tryMap { [weak self] apiKeyEntity -> Void in
                apiKeyEntity.name = item.name
                apiKeyEntity.customDescription = item.customDescription
                apiKeyEntity.dateUpdate = Date()
                
                try self?.context.save()
            }
            .mapError { error in
                return error
            }
            .map { _ in true }
            .eraseToAnyPublisher()
    }
    
    func deleteEntity(with item: ItemType) -> AnyPublisher<Bool, Error> {
        return fetchSingleItemFromDatabase(uuid: item.uuid)
            .tryMap { [weak self] apiKeyEntity -> Void in
                self?.context.delete(apiKeyEntity)
                try self?.context.save()
            }
            .mapError { error in
                return error
            }
            .map { _ in true }
            .eraseToAnyPublisher()
    }
    
    func clearData() -> AnyPublisher<Bool, Error> {
        return fetchDataFromDatabase()
            .tryMap { [weak self] apiKeyEntities -> Void in
                apiKeyEntities.forEach { entity in
                    autoreleasepool {
                        self?.context.delete(entity)
                    }
                }
                try self?.context.save()
            }
            .mapError { error in
                return error
            }
            .map { _ in true }
            .eraseToAnyPublisher()
    }

}
