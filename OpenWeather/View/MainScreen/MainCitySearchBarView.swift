//
//  MainCitySearchBarView.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

struct MainCitySearchBarView: View {
    
    @EnvironmentObject var themeColor: ThemeColor

    @Binding var selectedCityName: String
    
    @State var isAlertShown: Bool = false
    
    var cityName: String?
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Text(cityName ?? "No city found")
                .foregroundColor(themeColor.text)
            Spacer()
//            NavigationLink(
//                destination: CitySearchScreen(
//                    selectedCityName: $selectedCityName
//                )
//            ) {
//                Image(systemName: "magnifyingglass.circle")
//                    .foregroundColor(themeColor.text)
//            }
            Button {
                isAlertShown.toggle()
            }label: {
                Image(systemName: "magnifyingglass.circle")
                    .foregroundColor(themeColor.text)
            }

        }
        .frame(maxWidth: .infinity)
        .alert(isPresented: $isAlertShown, content: {
            Alert(
                title: Text("Coming soon!"),
                message: Text("Next releases will provide a city selector!"),
                dismissButton: Alert.Button.default(Text("Awesome!"))
            )
        })
        .preferredColorScheme(themeColor.colorScheme)
    }
}

struct MainCitySearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainCitySearchBarView(
            selectedCityName: .constant("Deerfield Beach"),
            cityName: "Deerfield Beach"
        )
            .environmentObject(ThemeColor(appTheme: AppTheme.dark.rawValue))
    }
}

