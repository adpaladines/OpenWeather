//
//  SavedLocationsSelectorSheetView.swift
//  OpenWeather
//
//  Created by andres paladines on 11/29/23.
//

import SwiftUI

struct SavedLocationsSelectorSheetView: View {
    
    //MARK: Environment
    @Environment(\.dismiss) var dismiss
    
    //MARK: EnvironmentObject
    @EnvironmentObject var themeColor: ThemeColor
    
    //MARK: StateObject
    @ObservedObject var viewModel = SavedLocationsViewModel(
        CDManager: ApiKeyCoreDataManager(
            context: PersistenceController.shared.backgroundContext
        )
    )
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(
                    columns: [
                        GridItem()
                    ],
                    spacing: 16) {
                        ForEach(0...20, id: \.self) { item in
                            ApiKeyCellView(
                                isSelected: true,
                                title: item.description
                            )
                            .frame(height: 46)
                            .containerBackground(withColor: themeColor.containerBackground)
                            .onTapGesture {
                                dismiss()
                            }
                        }
                    }
                    .padding(.top)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            .background(themeColor.screenBackground)
            .preferredColorScheme(themeColor.colorScheme)
            .navigationTitle("Select your city".localized())
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Cancel".localized()) {
                    print("Canceled")
                },
                trailing: Button("Done".localized()) {
                    print("Done")
                }
            )
        }
        .tint(themeColor.button)
        .preferredColorScheme(themeColor.colorScheme)
    }
}

#Preview {
    SavedLocationsSelectorSheetView()
        .environmentObject(ThemeColor(appTheme: AppTheme.dark.rawValue))
}
