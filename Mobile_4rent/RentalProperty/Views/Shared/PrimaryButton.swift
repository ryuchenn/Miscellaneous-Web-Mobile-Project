//
//  SmartButton.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/12.
//

import SwiftUI

struct PrimaryButton: View {
    var onClick: () -> Void
    var text: String = ""
    let isLoading: Bool
    
    var body: some View {
        Button(action: onClick) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }

                Text(text)
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
            }
            .padding(12)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(.borderedProminent)
        .tint(Color("OrangeColor"))
        .disabled(isLoading)
        .onAppear() {
//            self.isLoading = isLoading
            print(isLoading)
        }
        .onChange(of: isLoading) {
//            self.isLoading = isLoading
            print(isLoading)
        }
    }
}
