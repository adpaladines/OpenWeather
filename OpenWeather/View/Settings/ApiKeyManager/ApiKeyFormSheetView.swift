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
    @State private var isEdition: Bool
    @State private var isValidationError: Bool = false
    
    //MARK: Binding
    @Binding private var isPresented: Bool
    
    //MARK: FocusStates
    @FocusState var focus: FocusedField?
    @State var hasError: FocusedField?
    
    enum FocusedField: Hashable {
        case name, uuid, description
    }
    
    init(apiKeyData: ApiKeyData? = nil, viewModel: SettingsViewModel, isPresented: Binding<Bool>) {
        _isEdition = State(initialValue: apiKeyData != nil)
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
                    TextField("UUID (required)", text: $uuid)
                        .keyboardType(.default)
                        .disabled(isEdition)
                        .focused($focus, equals: .uuid)
                        .onSubmit {
                            focus = .name
                        }
                    TextField("Name (required)".localized(), text: $name)
                        .keyboardType(.default)
                        .focused($focus, equals: .name)
                        .onSubmit {
                            focus = .description
                        }
                    TextField("Description (optional)".localized(), text: $customDescription)
                        .keyboardType(.default)
                        .focused($focus, equals: .description)
                        .onSubmit {
                            print("SUBMIT")
                        }
                }
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        focus = .name
                    }
                }
                
                Section {
                    Button(action: {
                        submit()
                    }) {
                        Text("Save".localized())
                    }
                }
            }
            .modifier(FormHiddenBackground())
            .foregroundColor(themeColor.button)
            .background(themeColor.screenBackground)
            .navigationTitle(isEdition ? "Edition".localized() : "New Element".localized())
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                trailing: Button("Cancel".localized()) {
                    isPresented = false
                }
            )
        }
        .tint(themeColor.button)
        .preferredColorScheme(themeColor.colorScheme)
        .alert(isPresented: $isValidationError, content: {
            Alert(
                title: Text("Validation error!".localized()),
                message: Text("Make sure UUID and Name fields are filled.".localized()),
                dismissButton: Alert.Button.cancel(Text("Ok".localized()))
            )
        })
    }
    
    func submit() {
        guard uuid.isNotEmpty, name.isNotEmpty else {
            isValidationError = true
            return
        }
        
        let apiKey = ApiKeyData(
            uuid: uuid,
            name: name,
            customDescription: customDescription
        )
        viewModel.add(new: apiKey)
        viewModel.items.append(apiKey)
        isPresented = false
    }
}

#Preview {
    ApiKeyFormSheetView(
        apiKeyData: nil,
        viewModel: SettingsViewModel(
            CDManager: ApiKeyCoreDataManager(
                context: PersistenceController.shared.backgroundContext
            )
        ),
        isPresented: .constant(true)
    ).environmentObject(ThemeColor(appTheme: AppTheme.dark.rawValue))
}
