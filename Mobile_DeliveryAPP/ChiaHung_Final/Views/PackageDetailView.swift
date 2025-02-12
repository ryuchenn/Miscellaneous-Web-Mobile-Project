//
//  PackageDetailView.swift
//  ChiaHung_Final
//
//  Created by admin on 2025-02-11.
//

import SwiftUI

struct PackageDetailView: View {
    @State var package: Package
    @ObservedObject var packageInfo: PackageHelper
    @Environment(\.presentationMode) var presentationMode
    @State private var errorMsg = [String]()
    @State private var showAlert: Bool = false
    
    var body: some View {
        Form {
            
            List{
                Text("Package ID: \(package.PID)").bold()
                TextField("Address", text: $package.address)
                DatePicker("Delivery Date", selection: $package.date, displayedComponents: .date)
                Picker("Carrier", selection: $package.carrier) {
                    ForEach(carriers, id: \ .self) { Text($0) }
                }
                Toggle("Delivered", isOn: $package.status)
            }
            .listRowBackground(
                Capsule()
                    .fill(Color(white: 1, opacity: 0.7))
                    .padding(3)
            )
            
            Spacer()
                .listRowBackground(
                    Capsule()
                        .fill(Color(white: 1, opacity: 0))
                        .padding(3)
                )
            
            Button("Update Package") {
                let tmp = check()
                
                if !tmp{
                    packageInfo.update(package)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .listRowBackground(
                Capsule()
                    .fill(Color("Primary"))
            )
        }
        .navigationTitle("Update Package")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Add Failed"),
                message: Text(errorMsg.joined(separator: "\n")),
                dismissButton: .default(Text("OK")){
                    errorMsg.removeAll()
                }
            )
        }
        .scrollContentBackground(.hidden)
        .background(
            Image("backgroundImage")
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 3)
                .overlay(Color.indigo.opacity(0.4))
        )
        
    }
    
    private func check() -> Bool{
        for (name, value) in [("PackageID", package.PID), ("Address", package.address)] {
            if let errorMessage = ValidationHelper.check(name: name, value: value) {
                errorMsg.append(errorMessage)
            }
        }
        
        if !errorMsg.isEmpty {
            showAlert = true
            return true
        } else{
            return false
        }
    }
}
