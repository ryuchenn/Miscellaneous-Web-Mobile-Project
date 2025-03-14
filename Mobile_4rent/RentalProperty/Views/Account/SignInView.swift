//
//  LoginView.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/4.
//

import SwiftUI

struct SignInView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var accountController: AccountController
    @StateObject private var alert = useAlert()
    @StateObject private var isLoading = useToggle()
    
    @Binding var currentAuthView: AuthView
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var remember: Bool = false
    
    func handleFormSubmit() {
        alert.reset()

        for (name, value) in [
            ("Email", self.email),
            ("Password", self.password)
        ] {
            if let errorMessage = ValidationHelper.check(name: name, value: value) {
                alert.append(errorMessage)
            }
        }
        
        if !alert.messages.isEmpty {
            return alert.show(AlertType.Error)
        }
        
        isLoading.on()
        
        accountController.signIn(email: email, password: password, completion: { result in
            isLoading.off()
            if case .failure(let error) = result {
                alert.append("\(error.localizedDescription)")
                return alert.show(AlertType.Error)
            }
            accountController.rememberMe(enable: remember, email: email, password: password)
            dismiss()
        })
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    
                    ZStack {
                        Image("HeroBgImage")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .offset(x: UIScreen.main.bounds.width * -0.5)
                            .opacity(0.26)
                    } // Cover
                    
                    ZStack {
                        Spacer()
                        
                        VStack {
                            VStack(spacing: 12) {
                                Image("Brand")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 38)

                                VStack() {
                                    Text("Houses and Apartments for Rent. Simplified.")
                                        .font(.system(size: 15, weight: .light))
                                        .foregroundColor(Color("DarkBlueColor"))
                                }
                                .frame(maxWidth: .infinity, alignment: .bottom)
                            }
                            .padding(.vertical, 16)

                            VStack(spacing: 20) {
                                VStack(spacing: 0) {
                                    Text("Email")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(Color("DarkBlueColor"))
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    TextField("Email", text: $email)
                                        .padding(.vertical, 10)
                                        .overlay(
                                            Rectangle()
                                                .frame(height: 1)
                                                .foregroundColor(.gray.opacity(0.3)),
                                            alignment: .bottom
                                        )
                                }

                                VStack(spacing: 0) {
                                    Text("Password")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(Color("DarkBlueColor"))
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    SecureField("Password", text: $password)
                                        .padding(.vertical, 10)
                                        .overlay(
                                            Rectangle()
                                                .frame(height: 1)
                                                .foregroundColor(.gray.opacity(0.3)),
                                            alignment: .bottom
                                        )
                                }

                                VStack {
                                    Toggle("Remember Me", isOn: $remember)
                                        .frame(maxWidth: 166)
                                        .font(.system(size: 15))
                                        .foregroundColor(Color("DarkBlueColor"))
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)

                                PrimaryButton(
                                    onClick: handleFormSubmit,
                                    text: "Sign In",
                                    isLoading: isLoading.state
                                )

                                HStack {
                                    Text("Don't have an account?")
                                        .font(.system(size: 14, weight: .light))
                                        .foregroundColor(Color("TealBlueColor"))

                                    Button(action: {
                                        currentAuthView = .SignUp
                                    }) {
                                        Text("Sign Up")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Color("TealBlueColor"))
                                    }
                                } // Sign In
                            }
                            .padding(.horizontal, 26)
                            .padding(.vertical, 20)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .background(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color.white, location: 0.0),
                                .init(color: Color.white.opacity(0.12), location: 0.2),
                                .init(color: Color.white.opacity(0.4), location: 0.75),
                                .init(color: Color.white, location: 1.0)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    ) // Content
                }
            }
            .onAppear {
                if let data = accountController.getRememberedLoginData() {
                    email = data.email
                    password = data.password
                    remember = data.remember
                }
            }
            .alert(isPresented: $alert.state) {
                Alert(
                    title: Text(alert.title.rawValue),
                    message: Text(alert.messages.joined(separator: "\n"))
                )
            }
            .edgesIgnoringSafeArea(.all) // container
        }
    }
}
