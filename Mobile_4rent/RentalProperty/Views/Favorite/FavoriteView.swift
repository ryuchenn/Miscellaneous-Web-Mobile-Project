//
//  FavoriteView.swift
//  RentalProperty
//
//  Created by admin on 2025-03-07.
//

import SwiftUI

enum Layout {
    case List
    case Card
}

struct FavoriteView: View {
    @EnvironmentObject var accountController: AccountController
    @EnvironmentObject var propertyController: PropertyController
    @EnvironmentObject var favoriteController: FavoriteController
    
    @StateObject private var isLoading: useToggle = useToggle()
    @StateObject private var isDeleting: useToggle = useToggle()
    @StateObject private var alert = useAlert()
    
    @State private var selectedProperties: Set<String> = []
    @State var result = [Property]()
        
    func notLoggedInView() -> some View {
        LoginRequiredView().environmentObject(accountController)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if accountController.isLoggedIn() {
                    ScrollView {
                        HeaderSearchBar(
                            defaultItems: propertyController.properties.filter { property in
                                guard let propertyId = property.id else {
                                    return false
                                }
                                return favoriteController.favoriteIDs.contains(propertyId)
                            },
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
                                    Button(action: deleteSelectedFavorites) {
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
                } else {
                    notLoggedInView()
                }
            }
            .navigationTitle("Favorites")
            .alert(isPresented: $alert.state) {
                Alert(
                    title: Text(alert.title.rawValue),
                    message: Text(alert.messages.joined(separator: "\n"))
                )
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

    private func deleteSelectedFavorites() {
        guard !selectedProperties.isEmpty else { return }

        alert.reset()
        isLoading.on()
        
        if let userID = accountController.user?.uid {
            favoriteController.unlikeMultipleProperties(userID: userID, propertyIDs: Array(selectedProperties)) { result in
                isLoading.off()
                switch result {
                    case .success:
                        isDeleting.off()
                        selectedProperties.removeAll()
                    case .failure(let error):
                        alert.append("Failed to delete favorites: \(error.localizedDescription)")
                        alert.show(AlertType.Error)
                }
            }
        }
    }
}


#Preview {
    var selectedTab: Int = 0
    
    FavoriteView()
    .environmentObject(AccountController.getInstance())
    .environmentObject(PropertyController.getInstance())
    .environmentObject(FavoriteController.getInstance())
}
