//
//  Requestable.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation

protocol Requestable {
    
    var baseURL: String { get }
    var apiVersion: ApiVersion { get set }
    var path: String { get }
    var type: HttpRequestType { get } // get, post, put, delete, etc.
    func createURLRequest(isFake: Bool?) -> URLRequest?
    //TODO: Create bodyParams & queryParams, not just params
    var params: [String: String] { get set }

}

extension Requestable {
    
    var baseURL: String {
        return UrlEndpoints.shared.baseWeatherApi
    }
    var type: HttpRequestType {
        return self.type
    }
    var headers: [String:String] {
        return [:]
    }
    var params: [String: String] {
        return [:]
    }
    
    func createURLRequest(isFake: Bool? = false) -> URLRequest? {
        guard baseURL.isNotEmpty, path.isNotEmpty else  {
            return nil
        }

        guard !(isFake ?? true) else {
            let url = URL(string: path)
            return URLRequest(url: url!)
        }

        var urlComponents = URLComponents(string: baseURL + apiVersion.rawValue + path)
        if type == .get {
            var queryItems: [URLQueryItem] = []
            params.forEach { key, value in
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            urlComponents?.queryItems = queryItems
        }
        
        guard let url = urlComponents?.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = type.rawValue
        
        if type == .post {
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            request.httpBody = jsonData
        }
        
        return request
    }
    
}
