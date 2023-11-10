//
//  Serviceable.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation
import Combine

protocol Serviceable {
    func getDataFromApi(requestable: Requestable) async throws -> Data
    func getDataFromApiCombine(requestable: Requestable) -> AnyPublisher<Data, Error>
}
