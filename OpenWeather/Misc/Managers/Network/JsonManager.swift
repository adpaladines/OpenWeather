//
//  JsonManager.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation
import Combine

class JsonManager: Serviceable {
    
    func getDataFromApiCombine(requestable: Requestable) -> AnyPublisher<Data, Error> {
        guard let request = requestable.createURLRequest(isFake: true) else {
            return Fail(error: NetworkError.invalidUrl).eraseToAnyPublisher()
        }
        let bundle = Bundle(for: JsonManager.self)
        guard let url = bundle.url(forResource: request.url!.absoluteString, withExtension: "json") else {
            return Fail(error: NetworkError.invalidUrl).eraseToAnyPublisher()
        }
        do {
            let data = try Data(contentsOf: url)
            return Just(data)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }catch {
            print(error.localizedDescription)
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    
    func getDataFromApi(requestable: Requestable) async throws -> Data {
        guard let request = requestable.createURLRequest(isFake: true) else {
            throw NetworkError.invalidUrl
        }
        let bundle = Bundle(for: JsonManager.self)
        guard let url = bundle.url(forResource: request.url!.absoluteString, withExtension: "json") else {
            throw NetworkError.invalidUrl
        }
        do {
            let data = try Data(contentsOf: url)
            return data
        }catch {
            print(error.localizedDescription)
            throw error
        }
    }
        
}
