//
//  AddPackageView.swift
//  ChiaHung_Final
//
//  Created by admin on 2025-02-11.
//

import SwiftUI

// Views
struct AddPackageView: View {
    @ObservedObject var packageInfo: PackageHelper
    @Environment(\.presentationMode) var presentationMode
    
    @State private var PID = ""
    @State private var address = ""
    @State private var carrier = "FedEx"
    @State private var date = Date()
    @State private var status = false
    @State private var errorMsg = [String]()
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                List{
                    TextField("Package ID", text: $PID)
                    TextField("Address", text: $address)
                    DatePicker("Delivery Date", selection: $date, displayedComponents: .date)
                    Picker("Carrier", selection: $carrier) {
                        ForEach(carriers, id: \ .self) { Text($0) }
                    }
                    Toggle("Delivered", isOn: $status)
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
                
                Button("Add Package") {
                    let tmp = check()
                    
                    if !tmp{
                        packageInfo.add(Package(PID: PID, address: address, date: date, carrier: carrier, status: status))
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
            .navigationTitle("Add Package")
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
    }
    
    private func check() -> Bool{
        for (name, value) in [("PackageID", self.PID), ("Address", self.address)] {
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
