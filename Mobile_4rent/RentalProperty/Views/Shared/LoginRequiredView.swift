//
//  LoginRequiredView.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/10.
//

import SwiftUI

enum AuthView {
    case SignIn
    case SignUp
}

struct LoginRequiredView: View {
    @EnvironmentObject var accountController: AccountController
    @State var showAuthView = false
    @State var currentAuthView: AuthView = .SignIn
        
    var body: some View {
        VStack {
            Button(action: {
                showAuthView = true
            }) {
                Text("Please sign in to continue.")
            }
        }
        .sheet(isPresented: $showAuthView) {
            if currentAuthView == .SignUp {
                SignUpView(currentAuthView: $currentAuthView)
                    .environmentObject(accountController)
            } else {
                SignInView(currentAuthView: $currentAuthView)
                    .environmentObject(accountController)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("LightGrayColor"))
    }
}

#Preview {
    LoginRequiredView()
}
