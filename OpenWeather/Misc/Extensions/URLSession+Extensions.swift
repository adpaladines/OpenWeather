//
//  URLSession+Extensions.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation
import Combine

extension URLSession: URLSessionable {
    
    func getData(for urlRequest: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        try await self.data(for: urlRequest, delegate: delegate)
    }
    
//    func getDataCombine(for urlRequest: URLRequest, delegate: URLSessionTaskDelegate?) -> AnyPublisher<Data, Error> {
//        self.dataTaskPublisher(for: urlRequest)
//            .tryMap { [weak self] data, urlresponse in
//                if urlresponse.httpStatusCode 
//                guard data != nil else {
//                    return nil
//                }
//                 (data, nil)
//            }
//            .mapError { error in
//                return error
//            }
//            .eraseToAnyPublisher()
//    }
        
}

