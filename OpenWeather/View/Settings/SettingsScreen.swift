//
//  SettingsScreen.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI
import CoreData

struct AvailableLanguage {
    let code: String
    let description: String
}

struct SettingsScreen: View {
    
    //MARK: AppStorage
    @AppStorage("appTheme") var appTheme = AppTheme.dark.rawValue
    @AppStorage("app_lang") var appLang: String = "en"
    @AppStorage("currentMeasurementUnit") var currentMeasurementUnit: String = MeasurementUnit.standard.rawValue
    @AppStorage("appIconSelected") var appIconSelected: String = AppIconType.light.rawValue
    
    //MARK: EnvironmentObject
    @EnvironmentObject var themeColor: ThemeColor
    
    //MARK: StateObject
    @ObservedObject var viewModel = SettingsViewModel(
        CDManager: ApiKeyCoreDataManager(
            context: PersistenceController.shared.backgroundContext
        )
    )
    
    //MARK: State
    @State private var isDarkModeEnabled: Bool = true
    @State private var downloadViaWifiEnabled: Bool = false
    
    @State private var languageIndex = 0
    @State private var theme = AppTheme.dark
    @State private var measure = MeasurementUnit.standard
    @State private var appIcon = AppIconType.light
    
    let availableLanguages = [
        AvailableLanguage(code: "en", description: "English".localized()),
        AvailableLanguage(code: "es", description: "Spanish".localized()),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack {
                        VStack(alignment: .center) {
                            Text("Preferences".localized())
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .padding(.bottom)
                        HStack {
                            Image(systemName: "thermometer")
                                .frame(width: 24)
                            Text("Select your measure:".localized())
                            Spacer()
                            Picker(selection: $measure, label: Text("Measure".localized())) {
                                ForEach(MeasurementUnit.allCases, id:\.self) { measurement in
                                    Text(measurement.getUnit())
                                }
                            }
                            .tint(themeColor.button)
                            .onChange(of: measure) { measurement in
                                currentMeasurementUnit = measurement.rawValue
                            }
                        }
                        
                        HStack {
                            Image(systemName: "key.icloud")
                                .frame(width: 24)
                            Text("Api Key:".localized())
                            Spacer()
                            NavigationLink("Api Key vault".localized()) {
                                SettingsApiKeysScreen(viewModel: viewModel)
                            }
                            .padding(.horizontal, 12)
                            .tint(themeColor.button)
                            .onChange(of: measure) { measurement in
                                currentMeasurementUnit = measurement.rawValue
                            }
                            
                        }
                    }
                    .padding()
                    .background(themeColor.containerBackground)
                    .cornerRadius(12)
                    .padding(.bottom, 24)
                    
                    VStack {
                        VStack(alignment: .center) {
                            Text("Customizations".localized())
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .padding([.bottom])
                        HStack {
                            Image(systemName: "paintpalette")
                                .frame(width: 24)
                            Text("Select your theme:".localized())
                            Spacer()
                            Picker(selection: $theme, label: Text("Theme")) {
                                ForEach(AppTheme.allCases, id:\.self) {
                                    Text($0.name)
                                }
                            }
                            .tint(themeColor.button)
                            .onChange(of: theme) { newIndex in
                                appTheme = newIndex.rawValue
                            }
                        }
                        HStack {
                            Image(systemName: "doc.richtext")
                                .frame(width: 24)
                            Text("Select your language:".localized())
                            Spacer()
                            Picker(selection: $languageIndex, label: Text("Language")) {
                                ForEach(0 ..< availableLanguages.count) {
                                    Text(self.availableLanguages[$0].description)
                                }
                            }
                            .tint(themeColor.button)
                            .onChange(of: languageIndex) { newIndex in
                                let language = availableLanguages[newIndex].code
                                Bundle.setLanguage(lang: language)
                            }
                        }
                        
                        HStack {
                            Image(systemName: "apple.logo")
                                .frame(width: 24)
                            Text("Select your app icon:".localized())
                            Spacer()
                            Picker(selection: $appIcon, label: Text("Icon".localized())) {
                                ForEach(AppIconType.allCases, id:\.self) { icon in
                                    Text(icon.iconThemeName)
                                }
                            }
                            .tint(themeColor.button)
                            .onChange(of: appIcon) { icon in
                                Task {
                                    await viewModel.change(appIconType: icon)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(themeColor.containerBackground)
                    .cornerRadius(12)
                }
                .padding()
            }
            .background(themeColor.screenBackground)
            .navigationBarTitle("settings".localized())
            .preferredColorScheme(themeColor.colorScheme)
//            .padding()
            
            .onAppear {
                if let appTheme_ = AppTheme(rawValue: appTheme) {
                    theme = appTheme_
                }
                if let langIndex_ = availableLanguages.firstIndex(where: {$0.code == appLang}) {
                    languageIndex = langIndex_
                }
                if let measure_ = MeasurementUnit(rawValue: currentMeasurementUnit) {
                    measure = measure_
                }
                
                if let appIcon_ = AppIconType(rawValue: appIconSelected) {
                    appIcon = appIcon_
                    viewModel.set(
                        appIconManager: AppIconManager(),
                        currenIcon: appIcon
                    )
                }
                
            }
        }
    }
}

#Preview {
    SettingsScreen()
        .environmentObject(ThemeColor(appTheme: AppTheme.light.rawValue))
}

