//
//  SelectThemeBarView.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

struct SelectThemeBarView: View {
    
    @EnvironmentObject var themeColor: ThemeColor
    @AppStorage("appTheme") var appTheme = AppTheme.dark.rawValue
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Spacer()
            Menu {
                Button {
                    appTheme = AppTheme.light.rawValue
                }label: {
                    Text("Light")
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                }
                Button {
                    appTheme = AppTheme.dark.rawValue
                }label: {
                    Text("Dark")
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                }
                Button {
                    appTheme = AppTheme.monoLight.rawValue
                }label: {
                    Text("Mono Light")
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                }
                Button {
                    appTheme = AppTheme.monoDark.rawValue
                }label: {
                    Text("Mono Dark")
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Theme: "+appTheme)
                        .tint(themeColor.text)
                    ZStack {
//                        RoundedRectangle(cornerRadius: 12)
//                            .foregroundColor(Color(hex: "F1F1F1", alpha: 1.0))
                        Image(systemName: "chevron.down.circle")
                            .resizable()
                            .frame(width: 24, height: 24, alignment: .center)
                            .padding([.all], 2)
                            .tint(themeColor.text)
                    }
                    .frame(width: 56, height: 56, alignment: Alignment.center)
                }
               
            }
            .menuStyle(.automatic)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SelectThemeBarView_Previews: PreviewProvider {
    static var previews: some View {
        SelectThemeBarView()
            .environmentObject(ThemeColor(appTheme: AppTheme.dark.rawValue))
    }
}
