//
//  AvatarView.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/9.
//

import SwiftUI

struct AvatarView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var accountController: AccountController
    
    var body: some View {
        Button(action: { selectedTab = 4 }) {
            Group {
                if let avatar = accountController.user?.photoURL {
                    ImageLoader(url: avatar.absoluteString, width: 42, height: 42)
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 42, height: 42)
            .background(Color.white)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.gray.opacity(0.1), lineWidth: 1)
            )
        }
    }
}
