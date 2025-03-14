//
//  Setting.swift
//  RentalProperty
//
//  Created by admin on 2025-03-06.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var accountController: AccountController
    @EnvironmentObject var propertyController: PropertyController
    @EnvironmentObject var favoriteController: FavoriteController
    @State private var showUpdateUserProfile: Bool = false
    @State private var showLandlordSetting: Bool = false
    @State private var showTenantRequest: Bool = false
    @State private var showLandlordApprove: Bool = false
    @State var showAuthView = false
    @State var currentAuthView: AuthView = .SignIn
        
    func logout() {
        accountController.signOut()
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if !accountController.isLoggedIn() {
                    List {
                        Button(action: {
                            showAuthView = true
                        }) {
                            Text("Sign In / Sign Up").foregroundStyle(.blue)
                        }
                    }
                    .safeAreaPadding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                } else {
                    List {
                        Section(header: Text("Account")) {
                            HStack {
                                Text("Name")
                                
                                Spacer()
                                    
                                Text(accountController.user?.displayName ?? "-")
                            }
                            
                            HStack {
                                Text("Phone")
                                
                                Spacer()
                                
                                Text(accountController.user?.phoneNumber ?? "-")
                            }
                            
                            HStack {
                                Text("Email")
                                
                                Spacer()
                                
                                Text(accountController.user?.email ?? "-")
                            }
                            
                            Button(action: {
                                self.showUpdateUserProfile = true
                            }) {
                                Text("Update Profile")
                                    .foregroundStyle(.blue)
                            }
                        }

                        Section(header: Text("Landlord")) {
                            Button(action: { self.showLandlordSetting = true }) {
                                Text("My Properties").foregroundStyle(.blue)
                            }

                            Button(action: { self.showTenantRequest = true }) {
                                Text("Manage Tenant Requests").foregroundStyle(.blue)
                            }
                        }

                        Section(header: Text("Tenant")) {
                            Button(action: { self.showLandlordApprove = true }) {
                                Text("View Application Status").foregroundStyle(.blue)
                            }
                        }
                        
                        Button(action: logout) {
                            Text("Sign out").foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle("Account")
            .background(Color("LightGrayColor"))
            .navigationDestination(isPresented: $showUpdateUserProfile) {
                EditProfileView().environmentObject(accountController)
            }
            .navigationDestination(isPresented: $showTenantRequest) {
                TenantRequestView()
            }
            .navigationDestination(isPresented: $showLandlordApprove) {
                LandlordApproveView()
            }
            .navigationDestination(isPresented: $showLandlordSetting) {
                LandlordSettingView()
                    .environmentObject(accountController)
                    .environmentObject(propertyController)
                    .environmentObject(favoriteController)
            }
            .sheet(isPresented: $showAuthView){
                if currentAuthView == .SignUp {
                    SignUpView(currentAuthView: $currentAuthView).environmentObject(accountController)
                } else {
                    SignInView(currentAuthView: $currentAuthView).environmentObject(accountController)
                }
            }
        }
    }
}

#Preview {
    AccountView().environmentObject(AccountController.getInstance())
}
