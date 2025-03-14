//
//  UpdateUserView.swift
//  RentalProperty
//
//  Created by admin on 2025-03-08.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var accountController: AccountController
    @StateObject private var alert = useAlert()
    @StateObject private var isLoading = useToggle()

    @State private var displayName: String = ""
    @State private var phoneNumber: String = ""

    private func handleFormSubmit() {
        alert.reset()
        
        for (name, value) in [
            ("Name", self.displayName),
            ("Phone", self.phoneNumber)
        ] {
            if let errorMessage = ValidationHelper.check(name: name, value: value) {
                alert.append(errorMessage)
            }
        }
        
        if !alert.messages.isEmpty {
            return alert.show(AlertType.Error)
        }
        
        isLoading.on()
        
        accountController.updateUserProfile(displayName: displayName, phoneNumber: phoneNumber) { result in
            isLoading.off()
            switch result {
                case .success:
                    dismiss()
                case .failure(let error):
                    alert.append("\(error.localizedDescription)")
                    return alert.show(AlertType.Error)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Text("Name")
                        .frame(minWidth: 80, alignment: .leading)
                        
                    TextField("Required", text: $displayName)
                }
                
                HStack {
                    Text("Phone")
                        .frame(minWidth: 80, alignment: .leading)
                        
                    TextField("Required", text: $phoneNumber)
                       .keyboardType(.phonePad)
                }
            }
            .safeAreaPadding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            .navigationTitle("Edit Profile")
            .navigationBarItems(trailing:
                Button(action: handleFormSubmit) {
                    Text("Save").foregroundStyle(.white)
                }
                .foregroundStyle(.white)
                .disabled(isLoading.state)
            )
            .onAppear{
                displayName = accountController.user?.displayName ?? ""
                phoneNumber = accountController.user?.phoneNumber ?? ""
            }
            .alert(isPresented: $alert.state) {
                Alert(
                    title: Text(alert.title.rawValue),
                    message: Text(alert.messages.joined(separator: "\n"))
                )
            }
        }
    }

    
}
