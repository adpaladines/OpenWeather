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
    
    @State private var showActionSheet = false
    @State private var isFormOpened: Bool = false
    
    @State private var selectedObject: ApiKeyData? = nil
    
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
                        showActionSheet = true
                        selectedObject = item
                    }
                }
            }
            .padding(.top)
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .background(themeColor.screenBackground)
        .navigationBarTitle("API Keys".localized())
        .preferredColorScheme(themeColor.colorScheme)
        .toolbar(content: {
            Button {
                selectedObject = nil
                isFormOpened.toggle()
            }label: {
                Image(systemName: "plus.circle")
            }
        })
        .onAppear {
            viewModel.getItems()
        }
        .sheet(
            isPresented: $isFormOpened,
            onDismiss: {
                print("Sheet dismissed with status")
            },
            content: {
                ApiKeyFormSheetView(apiKeyData: selectedObject, viewModel: viewModel, isPresented: $isFormOpened)
            })
        .confirmationDialog(
            selectedObject != nil ? "Options for: \n\(selectedObject!.name)" : "Options:",
            isPresented: $showActionSheet,
            titleVisibility: Visibility.visible
        ) {
            Button("Select as default") {
                guard let uuid = selectedObject?.uuid else { return }
                apiKeySelected = uuid
            }
            Button("Edit") {
                isFormOpened = true
            }
            Button("Delete", role: .destructive) {
                guard
                    let item = selectedObject,
                    let index = viewModel.items.firstIndex(where: { $0.uuid == item.uuid })
                else
                { return }
                viewModel.delete(item: item)
                viewModel.items.remove(at: index)
            }
            Button("Cancel", role: .cancel) { }
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
