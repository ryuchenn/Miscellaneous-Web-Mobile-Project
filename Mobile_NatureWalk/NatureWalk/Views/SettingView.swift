//
//  Setting.swift
//  NatureWalk
//
//  Created by admin on 2025-02-06.
//

import SwiftUI

struct SettingView: View {
    @State private var redirectToLoginView : Bool = false
    
    func logout(){
        AccountService.logout()
        self.redirectToLoginView = true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                HStack {
                    Text("Name")
                    
                    Text(AccountService.name())
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.vertical, 6)
                
                HStack() {
                    Text("Email")
                    
                    Text(AccountService.email())
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.vertical, 6)
            }
            .frame(maxHeight: 120)
            
            List {
                Button(action: { logout() }) {
                    Text("Sign out")
                        .foregroundStyle(.red)
                }
                .padding(.vertical, 6)
            }
        }
        .navigationTitle("Settings")
        .fullScreenCover(isPresented: $redirectToLoginView) {
            ContentView()
        }
        .toolbar(.hidden, for: .tabBar) // hide tabBar
    } // body
}

#Preview {
    SettingView()
}
