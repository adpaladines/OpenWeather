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

            Text("Verify if you provided an Api Key in Settings tab.".localized())
                .foregroundColor(themeColor.warning)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.vertical)
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
