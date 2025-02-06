//
//  Receipt.swift
//  ChiaHung_PRINT
//
//  Created by admin on 2025-02-05.
//

import SwiftUI

struct Receipt: View {
    @EnvironmentObject var orders: PrintStore
    @State private var searchName: String = ""
    var body: some View {
        NavigationStack{
            VStack{
                List(orders.orders.filter { searchName.isEmpty || $0.phone.contains(searchName)  || $0.name.contains(searchName)}) { order in
                    NavigationLink(destination: ReceiptDetail(order: order)) {
                        VStack {
                            HStack{
                                Text("📕")
                                Text(order.name).font(.headline)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack{
                                Text("☎️")
                                Text(order.phone).font(.footnote)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .searchable(text: $searchName, prompt: "Enter Name or PhoneNumber")
                .navigationTitle("Receipt")
            }.scrollContentBackground(.hidden)
                .background(.clear)
                .background {
                    Image("wallpaper")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .blur(radius: 3)
                        .opacity(0.25)}
        }
        .padding()
        .scrollContentBackground(.hidden)
        .background(.clear)
        .background {
            Image("wallpaper")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 3)
                .opacity(0.4)}
    }
    
}
