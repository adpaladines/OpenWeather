//
//  SettingsApiKeysScreen.swift
//  OpenWeather
//
//  Created by andres paladines on 11/15/23.
//

import SwiftUI

struct SettingsApiKeysScreen: View {
    
    @AppStorage("api_key_selected") var apiKeySelected: String = ""
    @EnvironmentObject var themeColor: ThemeColor
    @ObservedObject var viewModel: SettingsViewModel
    
    @State private var isFormOpened: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(
                columns: [
                    GridItem()
                ],
                spacing: 16) {
                ForEach(viewModel.items) { item in
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
                isFormOpened.toggle()
                viewModel.add(new: ApiKeyData(uuid: UUID().uuidString, name: "Ex: \(Date().timeIntervalSince1970)", customDescription: "This is just an example to be saved in Core Data \(Date())."))
            }label: {
                Image(systemName: "plus.circle")
            }
        })
        .onAppear {
            viewModel.getItems()
        }
        .sheet(isPresented: $isFormOpened, onDismiss: {
            print("Sheet dismissed with status")
        }) {
            ApiKeyFormSheetView(viewModel: viewModel, isPresented: $isFormOpened)
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
