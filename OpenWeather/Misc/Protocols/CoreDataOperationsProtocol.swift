//
//  CoreDataOperationsProtocol.swift
//  OpenWeather
//
//  Created by andres paladines on 11/12/23.
//

import Foundation
import CoreData

protocol CoreDataOperationsProtocol {
    associatedtype ItemType
    
    var context: NSManagedObjectContext { get }
    
    init(context: NSManagedObjectContext)
    
}
