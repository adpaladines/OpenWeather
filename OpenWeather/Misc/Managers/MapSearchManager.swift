//
//  MapSearchManager.swift
//  OpenWeather
//
//  Created by andres paladines on 10/27/23.
//

import SwiftUI
import Combine
import MapKit

class MapSearchManager : NSObject, ObservableObject {
    
    @Published var searchTerm = ""
    @Published var locationResults : [MKLocalSearchCompletion] = []
    @Published var selectedObject: MKLocalSearchCompletion?
    
    private var currentPromise : ((Result<[MKLocalSearchCompletion], Error>) -> Void)?
    private var cancellables = Set<AnyCancellable>()
    private var searchCompleter = MKLocalSearchCompleter()
    private var cityNamesList = [String]()
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        
        $searchTerm
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap({ (currentSearchTerm) in
                self.searchTerm(searchTerm: currentSearchTerm)
            })
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished:
                    print("Search finished!")
                case .failure(let error):
                    print("Error:")
                    print(error.localizedDescription)
                }
            }, receiveValue: { (results) in
                self.locationResults = results
            })
            .store(in: &cancellables)
    }
    
    func searchTerm(searchTerm: String) -> Future<[MKLocalSearchCompletion], Error> {
        Future { promise in
            guard searchTerm.isNotEmpty else {
                promise(.success([]))
                return
            }
            self.searchCompleter.queryFragment = searchTerm
            self.currentPromise = promise
        }
    }
    
    var cityName: String {
        guard let obj = selectedObject, let cityName = getCity(from: obj.title) else {
            return ""
        }
        if cityNamesList.contains(where: { $0.contains(cityName)}) {
            return cityName
        }
        return ""
    }
    
}

extension MapSearchManager : MKLocalSearchCompleterDelegate {
    
    func getCity(from string: String) -> String? {
        if string.contains(",") {
            let splitByComma = string.components(separatedBy: ",")
            if splitByComma.count > 0 {
                return splitByComma[0]
            }
        }
        return nil
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {

        var cityCompletions: [MKLocalSearchCompletion] = []
        let completionResults = completer.results.filter({ (result) -> Bool in
            return result.title != ""
        })
        if completionResults.count > 0 {
            var newResults: [String] = []
            var newCityCompletions: [MKLocalSearchCompletion] = []
            for result in completionResults {
                if let cityName = getCity(from: result.title) {
                    if !newResults.contains(cityName) {
                        newResults.append(cityName)
                        newCityCompletions.append(result)
                    }
                }
            }
            if newResults.count > 0 {
                cityNamesList = newResults
                cityCompletions = newCityCompletions
            }
        }
        currentPromise?(.success(cityCompletions))
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        currentPromise?(.success([]))
    }
}
