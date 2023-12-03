//
//  MainCitySearchBarView.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

struct MainCitySearchBarView: View {
    
    //MARK: Environment
    @EnvironmentObject var themeColor: ThemeColor
    
    //MARK: Bindings
    @Binding var selectedCityName: String
    @Binding var isLocationSelectorOpen: Bool
    
    //MARK: State(internal)
    @State var isAlertShown: Bool = false
    
    var cityName: String?
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading) {
//                HStack {
//                    Button {
//                        isLocationSelectorOpen = true
//                    }label: {
//                        Image(systemName: "list.bullet")
//                            .fontWeight(.black)
//                            .foregroundColor(themeColor.button)
//                    }
//                    Spacer()
//                    NavigationLink(
//                        destination: CitySearchScreen(
//                            selectedCityName: $selectedCityName
//                        )
//                    ) {
//                        Image(systemName: "magnifyingglass")
//                            .fontWeight(.heavy)
//                            .foregroundColor(themeColor.button)
//                    }
//                }
                Button {
                    isAlertShown.toggle()
                }label: {
                    HStack {
                        Text(cityName ?? "No city found".localized())
                            .foregroundColor(themeColor.text)
                        Spacer()
                        Image(systemName: "magnifyingglass.circle")
                            .foregroundColor(themeColor.text)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .alert(isPresented: $isAlertShown, content: {
            Alert(
                title: Text("Coming soon!".localized()),
                message: Text("Next releases will provide a city selector!".localized()),
                dismissButton: Alert.Button.default(Text("Awesome!".localized()))
            )
        })
        .preferredColorScheme(themeColor.colorScheme)
    }
}

struct MainCitySearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainCitySearchBarView(
            selectedCityName: .constant("Deerfield Beach"),
            isLocationSelectorOpen: .constant(false), 
            cityName: "Deerfield Beach"
        )
            .environmentObject(ThemeColor(appTheme: AppTheme.dark.rawValue))
    }
}

