//
//  ConditionalDialogModifier.swift
//  OpenWeather
//
//  Created by andres paladines on 12/2/23.
//

import SwiftUI

struct ConditionalDialogModifier: ViewModifier {
    var selectedObject: ApiKeyData?
    @Binding var apiKeySelected: String
    @Binding var isFormOpened: Bool
    @Binding var showActionSheet: Bool
    @StateObject var viewModel: SettingsViewModel

    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return AnyView(
                content.alert(
                    selectedObject != nil ? "Options for: \n\(selectedObject!.name)" : "Options:",
                    isPresented: $showActionSheet,
                    actions: {
                        Button("Select as default".localized(), action: {
                            guard let uuid = selectedObject?.uuid else { return }
                            apiKeySelected = uuid
                        })
                        Button("Edit".localized(), action: {
                            isFormOpened = true
                        })
                        Button("Delete".localized(), role: .destructive, action: {
                            guard
                                let item = selectedObject,
                                let index = viewModel.items.firstIndex(where: { $0.uuid == item.uuid })
                            else
                            { return }
                            viewModel.delete(item: item)
                            viewModel.items.remove(at: index)
                        })
                        Button("Cancel".localized(), role: .cancel, action: {})
                    }
                )
            )
        } else {
            return AnyView(
                content.confirmationDialog(
                    selectedObject != nil ? "Options for: \n\(selectedObject!.name)" : "Options:",
                    isPresented: $showActionSheet,
                    titleVisibility: .visible
                ) {
                    Button("Select as default".localized()) {
                        guard let uuid = selectedObject?.uuid else { return }
                        apiKeySelected = uuid
                    }
                    Button("Edit".localized()) {
                        isFormOpened = true
                    }
                    Button("Delete".localized(), role: .destructive) {
                        guard
                            let item = selectedObject,
                            let index = viewModel.items.firstIndex(where: { $0.uuid == item.uuid })
                        else
                        { return }
                        viewModel.delete(item: item)
                        viewModel.items.remove(at: index)
                    }
                    Button("Cancel".localized(), role: .cancel) { }
                }
            )
        }
    }
}

extension View {
    func conditionalDialog(
        selectedObject: ApiKeyData?,
        apiKeySelected: Binding<String>,
        isFormOpened: Binding<Bool>,
        showActionSheet: Binding<Bool>,
        viewModel: SettingsViewModel
    ) -> some View {
        self.modifier(
            ConditionalDialogModifier(
                selectedObject: selectedObject,
                apiKeySelected: apiKeySelected,
                isFormOpened: isFormOpened,
                showActionSheet: showActionSheet,
                viewModel: viewModel
            )
        )
    }
}
