//
//  SettingsViewModel.swift
//  OpenWeather
//
//  Created by andres paladines on 10/27/23.
//

import Foundation

@MainActor
class SettingsViewModel: ObservableObject {
    
    var appIconType: AppIconType?
    var appIconManager: AppIconManagerProtocol?
        
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
