//
//  Login.swift
//  NatureWalk
//
//  Created by admin on 2025-02-06.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberUser: Bool = false
    @State private var isLoggedIn: Bool = false
    @State private var showAlert: Bool = false
    @State private var errorMsg = [String]()
    
    func login() {
        errorMsg.removeAll()

        for (name, value) in [("Email", self.email), ("Password", self.password)] {
            if let errorMessage = ValidationHelper.check(name: name, value: value) {
                errorMsg.append(errorMessage)
            }
        }
        
        if !errorMsg.isEmpty {
            showAlert = true
            return
        }

        if AccountService.login(email: email, password: password) {
            isLoggedIn = true
            AccountService.rememberMe(enable: rememberUser, email: email, password: password)
        } else {
            showAlert = true
            errorMsg.append("Incorrect username or password.")
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                ZStack {
                    Image("loginBackground")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .opacity(0.1)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                } // Cover
                
                ZStack {
                    Spacer()
                    
                    VStack {
                        VStack {
                            Image("cover")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .frame(height: 210)
                        
                        VStack(spacing: -3.8) {
                            Text("Nature Walk")
                                .font(.system(size: 30, weight: .heavy))
                                .foregroundColor(Color("Primary"))
                            
                            VStack() {
                                Text("Explore, Breathe, Connect with Nature")
                                    .font(.system(size: 16, weight: .light))
                                    .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.636))
                            }
                            .frame(maxWidth: .infinity, alignment: .bottom)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .bottom)
                        
                        VStack(spacing: 18) {
                            VStack(spacing: 0) {
                                Text("Email")
                                    .font(.system(size: 15))
                                    .bold()
                                    .foregroundColor(.primary)
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
                                    .font(.system(size: 15))
                                    .bold()
                                    .foregroundColor(.primary)
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
                                Toggle("Remember Me", isOn: $rememberUser)
                                    .frame(maxWidth: 166)
                                    .font(.system(size: 15))
                                    .foregroundColor(.primary)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            
                            Button(action: {
                                login()
                            }) {
                                Text("Sign In")
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .frame(maxWidth: .infinity)
                                    .font(.system(size: 18, weight: .bold))
                            }
                                .buttonStyle(.borderedProminent)
                                .tint(Color("Primary")) // Sign In
                            
                            HStack {
                                Text("Don't have an account?")
                                    .font(.system(size: 14, weight: .light))
                                    .foregroundColor(Color("Primary"))
                                
                                Button(action: {
                                    
                                }) {
                                    Text("Sign Up")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color("Primary"))
                                }
                            } // Sign Up
                        }
                        .padding(.horizontal, 26)
                        .padding(.vertical, 20)
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) // Content
            }
        }
        .onAppear {
            if let data = AccountService.getRememberedLoginData() {
                email = data.email
                password = data.password
                rememberUser = true
            }
        }
        .fullScreenCover(isPresented: $isLoggedIn){
            ContentView()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Login Failed"),
                message: Text(errorMsg.joined(separator: "\n"))
            )
        }
        .edgesIgnoringSafeArea(.all) // container
    }
}

#Preview {
    LoginView()
}
