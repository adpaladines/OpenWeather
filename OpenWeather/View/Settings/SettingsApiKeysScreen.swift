//
//  SettingsApiKeysScreen.swift
//  OpenWeather
//
//  Created by andres paladines on 11/15/23.
//

import SwiftUI

struct ApiKeyCellView: View {
    
    @EnvironmentObject var themeColor: ThemeColor
    var isSelected: Bool
    var title: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(themeColor.imageBackground)
                .overlay {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "checkmark.circle")
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                        .foregroundColor(themeColor.button)
                }
                .frame(width: 28, height: 28, alignment: .center)
                .padding(.leading)
            Text(title)
                .fontWeight(.medium)
                .foregroundColor(themeColor.text)
            Spacer()
        }
        .padding(.trailing)
    }
    
}

struct SettingsApiKeysScreen: View {
    
    @AppStorage("api_key_selected") var apiKeySelected: String = ""
    @EnvironmentObject var themeColor: ThemeColor
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(
                columns: [
                    GridItem()
                ],
                spacing: 16) {
                ForEach(viewModel.testItems) { item in
                    ApiKeyCellView(
                        isSelected: apiKeySelected == item.uuid,
                        title: item.name
                    )
                    .frame(height: 46)
                    .containerBackground(withColor: themeColor.containerBackground)
                    .onTapGesture {
                        apiKeySelected = item.uuid
                    }
                }
            }
            
//            .frame(maxWidth: 640)
            .padding(.top)
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .background(themeColor.screenBackground)
        .navigationBarTitle("API Keys".localized())
        .preferredColorScheme(themeColor.colorScheme)
        .toolbar(content: {
            Button {
                viewModel.add(new: ApiKeyData(uuid: UUID().uuidString, name: "Ex: \(Date().timeIntervalSince1970)", customDescription: "This is just an example to be saved in Core Data \(Date())."))
            }label: {
                Image(systemName: "plus.circle")
            }
        })
        .onAppear {
            viewModel.getItems()
        }
    }
}

#Preview {
    SettingsApiKeysScreen(
        viewModel: SettingsViewModel(
            CDManager: ApiKeyCoreDataManager(
                context: PersistenceController.shared.backgroundContext
            )
        )
    )
    .environmentObject(ThemeColor(appTheme: AppTheme.light.rawValue))
    .environmentObject(CurrentLanguage(code: "es"))
}
