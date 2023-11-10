//
//  Services.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation
import Combine

class Services {
    var urlSession: URLSessionable
    
    init(urlSession: URLSessionable = URLSession.shared) {
        self.urlSession = urlSession
    }

}

extension Services: Serviceable {
    
    func getDataFromApiCombine(requestable: Requestable) -> AnyPublisher<Data, Error> {
        guard let urlRequest = requestable.createURLRequest() else {
            return Fail(error: NetworkError.invalidUrl).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, response: URLResponse) in
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    if (response as? HTTPURLResponse)?.statusCode == 404 {
                        throw NetworkError.dataNotFound
                    }else {
                        throw NetworkError.response((response as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                }
                return data
            }
            .eraseToAnyPublisher()
    }
    
}
