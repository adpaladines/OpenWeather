//
//  SavedLocationsViewModel.swift
//  OpenWeather
//
//  Created by andres paladines on 11/29/23.
//

import Foundation
import CoreData
import Combine

@MainActor
class SavedLocationsViewModel: ObservableObject {
    
    @Published var items: [ApiKeyData] = []
    @Published var customError: NetworkError
    @Published var success: Bool = false
    
    private var appIconType: AppIconType?
    private var appIconManager: AppIconManagerProtocol?
    private var CDManager: ApiKeyCoreDataManager
    private var cancellables: Set<AnyCancellable> = []
    
    init(CDManager: ApiKeyCoreDataManager) {
        self.CDManager = CDManager
        self.customError = NetworkError.none
    }
    
    func set(appIconManager: AppIconManagerProtocol, currenIcon: AppIconType) {
        self.appIconManager = appIconManager
        self.appIconType = currenIcon
    }
    
    func change(appIconType: AppIconType) async {
        guard let iconManager = appIconManager else {
            return
        }
        let changed = await iconManager.changeAppIcon(with: appIconType)
        print("Icon " + (changed ? "Changed!" : "Not changed!") )
    }
    
}

//MARK: - CoreData Management
extension SavedLocationsViewModel {
    
    func getItems() {
        CDManager.fetchDataFromDatabase()
            .receive(on: RunLoop.main)
            .tryMap { itemEntities in
                return itemEntities.compactMap { ApiKeyData(from: $0) }
            }
            .sink { [weak self] completion in
                self?.manageErrorStatus(completion: completion)
            } receiveValue: { [weak self] items in
                self?.items = items
            }
            .store(in: &cancellables)
    }
    
    func add(new item: ApiKeyData) {
        CDManager.saveDataIntoDatabase(item: item)
            .sink { [weak self] completion in
                self?.manageErrorStatus(completion: completion)
            } receiveValue: { [weak self] success in
                self?.success = success
            }
            .store(in: &cancellables)
    }
    
    func update(item: ApiKeyData) async {
        CDManager.updateApiKeyEntity(with: item)
            .sink { [weak self] completion in
                self?.manageErrorStatus(completion: completion)
            } receiveValue: { [weak self] success in
                self?.success = success
            }
            .store(in: &cancellables)
    }
    
    func delete(item: ApiKeyData) {
        CDManager.deleteEntity(with: item)
            .sink { [weak self] completion in
                self?.manageErrorStatus(completion: completion)
            } receiveValue: { [weak self] success in
                self?.success = success
            }
            .store(in: &cancellables)
    }
    
    func manageErrorStatus(completion: Subscribers.Completion<Error> ) {
        switch completion {
        case .finished:
            customError.setCustomErrorStatus(with: nil)
        case .failure(let error):
            customError.setCustomErrorStatus(with: error)
        }
    }
    
}
