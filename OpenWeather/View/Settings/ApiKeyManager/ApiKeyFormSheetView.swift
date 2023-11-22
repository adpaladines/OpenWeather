//
//  ApiKeyFormSheetView.swift
//  OpenWeather
//
//  Created by andres paladines on 11/17/23.
//

import SwiftUI

struct ApiKeyFormSheetView: View {
    
    //MARK: EnvironmentObject
    @EnvironmentObject var themeColor: ThemeColor
    
    //MARK: StateObject
    @StateObject var viewModel: SettingsViewModel
    
    //MARK: Wrappers
    @State private var uuid: String
    @State private var name: String
    @State private var customDescription: String
    @State private var isEditing: Bool
    
    @Binding private var isPresented: Bool
    
    init(apiKeyData: ApiKeyData? = nil, viewModel: SettingsViewModel, isPresented: Binding<Bool>) {
        _isEditing = State(initialValue: apiKeyData != nil)
        _uuid = State(initialValue: apiKeyData?.uuid ?? "")
        _name = State(initialValue: apiKeyData?.name ?? "")
        _customDescription = State(initialValue: apiKeyData?.customDescription ?? "")

        _viewModel = StateObject(wrappedValue: viewModel)
        _isPresented = isPresented
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details".localized())) {
                    TextField("UUID", text: $uuid)
                        .keyboardType(.default)
                        .disabled(isEditing)
                        
                    TextField("Name".localized(), text: $name)
                        .keyboardType(.default)
                    TextField("Description".localized(), text: $customDescription)
                        .keyboardType(.default)
                }
                
                Section {
                    Button(action: {
                        let apiKey = ApiKeyData(
                            uuid: uuid,
                            name: name,
                            customDescription: customDescription
                        )
                        viewModel.add(new: apiKey)
                        viewModel.items.append(apiKey)
                        isPresented = false
                    }) {
                        Text("Save".localized())
                    }
                }
                
            }
            .modifier(FormHiddenBackground())
            .foregroundColor(themeColor.button)
            .background(themeColor.screenBackground)
            .navigationTitle(isEditing ? "Edition".localized() : "New Element".localized())
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                trailing: Button("Cancel".localized()) {
                    isPresented = false
                }
            )
        }
        .tint(themeColor.button)
        .preferredColorScheme(themeColor.colorScheme)
    }
}

#Preview {
    ApiKeyFormSheetView(
        viewModel: SettingsViewModel(
            CDManager: ApiKeyCoreDataManager(
                context: PersistenceController.shared.backgroundContext
            )
        ),
        isPresented: .constant(true)
    ).environmentObject(ThemeColor(appTheme: AppTheme.dark.rawValue))
}
