//
//  CoreDataOperationsProtocol.swift
//  OpenWeather
//
//  Created by andres paladines on 11/12/23.
//

import Foundation
import CoreData
import Combine

protocol CoreDataOperationsProtocol {
    associatedtype ItemType
    associatedtype ItemEntityType: NSManagedObject
    
    var context: NSManagedObjectContext { get }
    
    init(context: NSManagedObjectContext)
    
    func fetchSingleItemFromDatabase(uuid: String) -> AnyPublisher<ItemEntityType, Error>
    func fetchDataFromDatabase() -> AnyPublisher<[ItemEntityType], Error>
    func saveDataIntoDatabase(item: ItemType) -> AnyPublisher<Bool, Error>
    func updateApiKeyEntity(with item: ItemType) -> AnyPublisher<Bool, Error>
    func deleteEntity(with item: ItemType) -> AnyPublisher<Bool, Error>
    func clearData() -> AnyPublisher<Bool, Error>    
}
