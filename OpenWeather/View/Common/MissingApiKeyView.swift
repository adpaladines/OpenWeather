//
//  MissingApiKeyView.swift
//  OpenWeather
//
//  Created by andres paladines on 11/26/23.
//

import SwiftUI

struct MissingApiKeyView: View {
    
    @EnvironmentObject var themeColor: ThemeColor
    let error: Error
    let showApiKeyWarning: Bool
    let showSettingsButton: Bool
    
    init(error: Error, showApiKeyWarning: Bool = true, showSettingsButton: Bool = false) {
        self.error = error
        self.showApiKeyWarning = showApiKeyWarning
        self.showSettingsButton = showSettingsButton
    }
    
    var body: some View {
        VStack {
            Spacer()

            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(themeColor.error)
                .padding(.bottom, 20)
            
            Text("We got an error.".localized())
                .font(.title)
                .foregroundColor(themeColor.error)
                .padding(.bottom, 20)
            
            Text(error.localizedDescription)
                .fontWeight(.semibold)
                .foregroundColor(themeColor.gray)
                .multilineTextAlignment(.center)
                .padding(.bottom, 30)

            if showApiKeyWarning {
                Text("Verify if you provided an Api Key in Settings tab.".localized())
                    .foregroundColor(themeColor.warning)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            if showSettingsButton {
                Button(action: {
                    openAppSettings()
                }) {
                    Text("Open Settings")
                        .padding(.all, 8)
                }
                .tint(themeColor.button)
            }
            Spacer()
        }
        .padding(.vertical)
        .preferredColorScheme(themeColor.colorScheme)
    }
    
    private func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.openURL(settingsURL)
    }
}

struct MissingApiKeyView_Previews: PreviewProvider {
    
    static var previews: some View {

        
        let contentView = MissingApiKeyView(error: NetworkError.dataNotFound)
        return contentView
            .environmentObject(ThemeColor(appTheme: "light"))
            .environmentObject(CurrentLanguage(code: "es"))

    }
}
