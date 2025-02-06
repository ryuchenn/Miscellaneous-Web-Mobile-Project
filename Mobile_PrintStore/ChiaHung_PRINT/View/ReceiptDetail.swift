//
//  ReceiptDetail.swift
//  ChiaHung_PRINT
//
//  Created by admin on 2025-02-05.
//

import SwiftUI

struct ReceiptDetail: View {
    
    let order: Order
    
    var body: some View {
        GroupBox("Receipt"){
            Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 8) {
                GridRow {
                    Text("Field").bold()
                    Text("Options").bold()
                }
                .font(.title2)
                
                Divider()
                
                GridRow {
                    Text("Name")
                    Text(order.name)
                }
                
                GridRow {
                    Text("Phone")
                    Text(order.phone)
                }
                
                GridRow {
                    Text("Type")
                    Text(order.type)
                }
                
                GridRow {
                    Text("Size")
                    Text(order.size)
                }
                
                GridRow {
                    Text("Quantity")
                    Text("\(order.quantity)")
                }
                
                GridRow {
                    Text("Discount")
                    Text("$\(order.discount, specifier: "%.2f")")
                }
                
                GridRow {
                    Text("Tax")
                    Text("$\(order.tax, specifier: "%.2f")")
                }
                
                GridRow {
                    Text("Delivery Cost")
                    Text("$\(order.deliveryCost, specifier: "%.2f")")
                }
                
                Divider()
                
                GridRow {
                    Color.clear
                        .gridCellColumns(1)
                        .gridCellUnsizedAxes(.vertical)
                    Text("$\(order.total, specifier: "%.2f")")
                        .bold()
                        .foregroundColor(.red)
                        .font(.title)
                }
            }
            .frame(maxWidth: .infinity)
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
