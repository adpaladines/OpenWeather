//
//  Bundle+Extensions.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

extension Bundle {
    
    private static var bundle: Bundle!
    
    public static func localizedBundle() -> Bundle {
        @AppStorage("app_lang") var appLang: String = "en"
        
        if bundle == nil {
            print(appLang)
            let path = Bundle.main.path(forResource: appLang, ofType: "lproj")
            bundle = Bundle(path: path!)
        }
        
        return bundle
    }
    
    //Bundle.setLanguage(lang: "en")
    public static func setLanguage(lang: String) {
        @AppStorage("app_lang") var appLang: String = "en"
        appLang = lang
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        bundle = Bundle(path: path!)
    }
    
}
