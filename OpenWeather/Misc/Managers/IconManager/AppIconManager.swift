//
//  AppIconManager.swift
//  OpenWeather
//
//  Created by andres paladines on 10/27/23.
//

import Foundation
import UIKit

protocol AppIconManagerProtocol {
    func isSupported() async -> Bool
    func changeAppIcon(with icon: AppIconType) async -> Bool
}

enum AppIconType: String, CaseIterable {
    case light
    case dark
}

extension AppIconType {
    
    var getIconName: String? {
        switch self {
        case .light:
            return nil
        case .dark:
            return "AppIcon-2"
        }
    }
    
    var iconThemeName: String {
        switch self {
        case .light:
            return "Light".localized()
        case .dark:
            return "Dark".localized()
        }
    }
}

final class AppIconManager: AppIconManagerProtocol {
    
    func isSupported() async -> Bool {
        let supported = await UIApplication.shared.supportsAlternateIcons
        return supported
    }
    
    func changeAppIcon(with icon: AppIconType) async -> Bool {
        let iconName = icon.getIconName
        var error_: Error?
        guard await UIApplication.shared.alternateIconName != iconName else { return true }
        
        await UIApplication.shared.setAlternateIconName(icon.getIconName) { error in
            error_ = error
            print(error?.localizedDescription ?? "Success!")
        }
        guard error_ == nil else {
            return false
        }
        return true
    }
    
}
