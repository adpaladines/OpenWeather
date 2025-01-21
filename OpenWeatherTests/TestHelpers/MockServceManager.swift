//
//  MockServceManager.swift
//  OpenWeather
//
//  Created by andres paladines on 1/20/25.
//

@testable import OpenWeather
import Foundation
import Combine

enum StatusMockServiceTests: String {
    case success = ""
    case parsingError = "_parsing-error"
}

final class MockServiceManager: Serviceable {
    var mockData: Data?
    var mockError: Error?
    var status: StatusMockServiceTests?
    
    func getDataFromApiCombine(requestable: Requestable) -> AnyPublisher<Data, Error> {
        if let data = mockData {
            return Just(data)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        guard let request = requestable.createURLRequest(isFake: true) else {
            return Fail(error: NetworkError.invalidUrl).eraseToAnyPublisher()
        }
        let bundle = Bundle(for: JsonManager.self)
        let fileStatus = status?.rawValue ?? ""
        let fileName = request.url!.absoluteString + fileStatus
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
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
