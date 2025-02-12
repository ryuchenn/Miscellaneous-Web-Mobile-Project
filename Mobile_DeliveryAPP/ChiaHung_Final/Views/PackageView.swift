//
//  PackageView.swift
//  ChiaHung_Final
//
//  Created by admin on 2025-02-11.
//

import SwiftUI

struct PackageView: View {
    @StateObject var packageInfo = PackageHelper()
    @State private var showAdd = false
    @State private var showSearch = false
    
    var body: some View {
        VStack{
            NavigationStack {
                VStack {
                    if showSearch {
                        TextField("Search (ID / Search)", text: $packageInfo.searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                                .padding(.bottom, 20)
                                .transition(.move(edge: .top))
                                .opacity(0.7)
                    }
           
                    List {
                        ForEach(packageInfo.search) { package in
                            NavigationLink(destination: PackageDetailView(package: package, packageInfo: packageInfo)) {
                                HStack {
                                    Image(systemName: package.status ? "checkmark.circle.fill" : "shippingbox.fill")
                                        .foregroundColor(package.status ? .green : .orange)
                                        .font(.system(size: 35))
                                    
                                    VStack(alignment: .leading) {
                                        
                                        Text(package.PID)
                                            .font(.title3)
                                            .bold()
                                            .foregroundColor(.primary)
                                            .multilineTextAlignment(.leading)
                                        
                                        Text("\(package.date, formatter: datePicker)")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                    
                                }
                            }
                        }
                        .onDelete(perform: packageInfo.remove)
                        .listRowBackground(
                            Capsule()
                                .fill(Color(white: 1, opacity: 0.7))
                                .padding(3)
                        )
                    } // List end
                } // VStack
                .navigationTitle("DeliveryAPP")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack{
                            Button(action: { showAdd = true }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.black)
                            }
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showSearch.toggle()
                                }
                            }) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(
                    Image("backgroundImage")
                        .edgesIgnoringSafeArea(.all)
                        .blur(radius: 3)
                        .overlay(Color.indigo.opacity(0.4))
                )
                .navigationDestination(isPresented: $showAdd){
                    AddPackageView(packageInfo: packageInfo)
                }
                
            } // NavigationStack
        } // VStack
    }
}

