//
//  LandlordSettingView.swift
//  RentalProperty
//
//  Created by admin on 2025-03-09.
//
import SwiftUI

struct LandlordSettingView: View {
    @EnvironmentObject var accountController: AccountController
    @EnvironmentObject var propertyController: PropertyController
    
    @StateObject private var isLoading: useToggle = useToggle()
    @StateObject private var isDeleting: useToggle = useToggle()
    @StateObject private var alert = useAlert()
    
    @State private var properties: [Property] = []
    @State private var selectedProperties: Set<String> = []
    @State var result = [Property]()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HeaderSearchBar(
                   defaultItems: properties,
                   result: $result
                )
                
                if isLoading.state {
                    LoadingView()
                } else {
                    ForEach(result) { property in
                        HStack {
                            if isDeleting.state {
                                Image(systemName: selectedProperties.contains(property.id ?? "") ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        toggleSelection(property.id ?? "")
                                    }
                            }
                            PropertyCard(property: property)
                        }
                        .padding(.horizontal, isDeleting.state ? nil : 0)
                        .padding(.vertical, 0)
                    }
                }
            }
            .navigationTitle("My Properties")
            .onAppear(perform: fetchLandlordData)
            .toolbar {
                if accountController.isLoggedIn() {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation {
                                isDeleting.toggle()
                                selectedProperties.removeAll()
                            }
                        }) {
                            Image(systemName: isDeleting.state ? "xmark.circle.fill" : "trash.fill")
                                .foregroundColor(.white)
                        }
                    }

                    if isDeleting.state {
                        ToolbarItemGroup(placement: .bottomBar) {
                            Button(action: deleteSelectedProperties) {
                                Text("Delete Selected (\(selectedProperties.count))")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(selectedProperties.isEmpty ? Color.gray : Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .disabled(selectedProperties.isEmpty)
                        }
                    }
                }
            }
            .alert(isPresented: $alert.state) {
                Alert(
                    title: Text(alert.title.rawValue),
                    message: Text(alert.messages.joined(separator: "\n"))
                )
            }
        }
    }
    
    private func fetchLandlordData() {
        guard accountController.isLoggedIn() else { return }

        alert.reset()
        isLoading.on()

        if let userID = accountController.user?.uid {
            propertyController.fetchByContactID(uid: userID) { result in
                isLoading.off()
                switch result {
                    case .success(let fetchedProperties):
                        self.properties = fetchedProperties
                    case .failure(let error):
                        alert.append("Failed to load properties: \(error.localizedDescription)")
                        alert.show(AlertType.Error)
                }
            }
        }
    }

    private func toggleSelection(_ propertyID: String) {
        if selectedProperties.contains(propertyID) {
            selectedProperties.remove(propertyID)
        } else {
            selectedProperties.insert(propertyID)
        }
    }

    private func deleteSelectedProperties() {
        guard !selectedProperties.isEmpty else { return }

        alert.reset()
        isLoading.on()
        
        propertyController.deleteMultipleProperties(propertyIDs: Array(selectedProperties)) { result in
            isLoading.off()
            switch result {
                case .success:
                    isDeleting.off()
                    fetchLandlordData()
                    selectedProperties.removeAll()
                case .failure(let error):
                    alert.append("Failed to delete properties: \(error.localizedDescription)")
                    alert.show(AlertType.Error)
            }
        }
    }
}
