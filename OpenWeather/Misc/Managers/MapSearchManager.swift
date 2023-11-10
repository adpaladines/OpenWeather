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
//    @Published var locationResults : [MKLocalSearchCompletion] = []
    @Published var locationResultStrings : [String] = []
    @Published var searchTerm = ""
    
    private var cancellables : Set<AnyCancellable> = []
    
    private var searchCompleter = MKLocalSearchCompleter()
//    private var currentPromise : ((Result<[MKLocalSearchCompletion], Error>) -> Void)?
    private var currentPromiseStrings : ((Result<[String], Error>) -> Void)?

    override init() {
        super.init()
        searchCompleter.delegate = self
        
        $searchTerm
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap({ (currentSearchTerm) in
                self.searchTermToResults(searchTerm: currentSearchTerm)
            })
            .sink(receiveCompletion: { (completion) in
                //handle error
            }, receiveValue: { (results) in
//                self.locationResults = results
                self.locationResultStrings = results
            })
            .store(in: &cancellables)
    }
    
//    func searchTermToResults(searchTerm: String) -> Future<[MKLocalSearchCompletion], Error> {
//        Future { promise in
//            self.searchCompleter.queryFragment = searchTerm
//            self.currentPromise = promise
//        }
//    }
    
    func searchTermToResults(searchTerm: String) -> Future<[String], Error> {
        Future { promise in
            self.searchCompleter.queryFragment = searchTerm
            self.currentPromiseStrings = promise
        }
    }
    
}

extension MapSearchManager : MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        currentPromise?(.success(completer.results))
        var cityResults: [String] = []
        let completionResults = completer.results.filter({ (result) -> Bool in
            return result.title != ""
        })
        if completionResults.count > 0 {
            var newResults: [String] = []
            for result in completionResults {
                if result.title.contains(",") {
                    let splitByComma = result.title.components(separatedBy: ",")
                    if splitByComma.count > 0 {
                        if !newResults.contains(splitByComma[0]) {
                            newResults.append(splitByComma[0])
                        }
                    }
                }
            }
            if newResults.count > 0 {
                cityResults = newResults
            }
        }
        currentPromiseStrings?(.success(cityResults))
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        //could deal with the error here, but beware that it will finish the Combine publisher stream
        //currentPromise?(.failure(error))
    }
}
