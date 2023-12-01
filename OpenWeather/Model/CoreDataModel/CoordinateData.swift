//
//  CoordinateData.swift
//  OpenWeather
//
//  Created by andres paladines on 11/29/23.
//

import Foundation
import CoreData
import Combine

struct CoordinateEntityData: Identifiable {
    let customID: String
    let cityName: String
    let latitude: Double
    let longitude: Double
    let isSelected: Bool
    let dateCreation: Date
    let dateUpdate: Date
    
    init(customID: String, name: String, latitude: Double, longitude: Double, isSelected: Bool, dateCreation: Date? = nil,
         dateUpdate: Date? = nil) {
        self.customID = customID
        self.cityName = name
        self.latitude = latitude
        self.longitude = longitude
        self.isSelected = isSelected
        self.dateCreation = dateCreation ?? Date()
        self.dateUpdate = dateUpdate ?? Date()
    }
    
    init(from entity: CoordinateEntity) {
        self.customID = entity.customID ?? UUID().uuidString
        self.cityName = entity.cityName ?? "No name registered".localized()
        self.latitude = entity.latitude
        self.longitude = entity.longitude
        self.isSelected = entity.isSelected
        self.dateCreation = entity.dateCreation ?? Date()
        self.dateUpdate = entity.dateUpdate ?? Date()
    }

    var id: String {
        customID
    }
}

class CoordinateEntityCoreDataManager: CoreDataOperationsProtocol {
    
    typealias ItemType = CoordinateEntityData
    typealias ItemEntityType = CoordinateEntity
    
    let context: NSManagedObjectContext
    
    required init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchSingleItemFromDatabase(uuid: String) -> AnyPublisher<ItemEntityType, Error> {
        let fetchRequest: NSFetchRequest<ItemEntityType> = ItemEntityType.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", uuid)
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
        let itemEntity = ItemEntityType(context: context)
        itemEntity.customID = item.customID 
        itemEntity.cityName = item.cityName 
        itemEntity.latitude = item.latitude
        itemEntity.longitude = item.longitude
        itemEntity.isSelected = item.isSelected
        itemEntity.dateCreation = Date()
        itemEntity.dateUpdate = Date()
        
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
        return fetchSingleItemFromDatabase(uuid: item.customID)
            .tryMap { [weak self] apiKeyEntity -> Void in
                apiKeyEntity.cityName = item.cityName
                apiKeyEntity.latitude = item.latitude
                apiKeyEntity.longitude = item.longitude
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
        return fetchSingleItemFromDatabase(uuid: item.customID)
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
