//
//  PrintSelection.swift
//  ChiaHung_PRINT
//
//  Created by admin on 2025-02-05.
//
import SwiftUI

struct PrintSelection: View {
    @EnvironmentObject var orders: PrintStore
    
    @State private var type = "Photo"
    @State private var size = "4x6"
    @State private var quantity = 1
    @State private var name = ""
    @State private var phone = ""
    @State private var promotionCode = ""
    @State private var estimatedPrice = 0.0
    
    @State private var isDelivery : Bool  = false
    @State private var showReceipt : Bool = false
    @State private var showAlert : Bool = false
    @State private var order : Order?
    
    let sizes: [String: [String]] = [
        "Photo": ["4x6", "6x8", "8x12"],
        "Canvas": ["12x16", "16x20", "18x24"]
    ]
    
    let prices: [String: Double] = [
        "4x6": 6.99, "6x8": 8.99, "8x12": 10.99,
        "12x16": 14.99, "16x20": 18.99, "18x24": 22.99
    ]
    
    let existedPromotion: [String: Double] = ["PRINT20250205": 0.3, "PRINT10": 0.8, "PRINT15": 0.95, "MEMORIES15": 0.85]
    
    func placeOrder() -> Bool {
        if !promotionCode.isEmpty && existedPromotion[promotionCode] == nil{
            self.showAlert = true
            return false
        }
        
        let price = prices[size]! * Double(quantity)
        let discount = (existedPromotion[promotionCode] != nil ? min(price * existedPromotion[promotionCode]!, 15.0) : 0)
        let tax = (price - discount) * 0.13
        let total = (price - discount) + tax + (isDelivery ? 5.99 : 0)
        
        order = Order(
            type: type,
            size: size,
            quantity: quantity,
            name: name,
            phone: phone,
            promotionCode: promotionCode,
            discount: discount,
            tax: tax,
            total: total,
            deliveryCost: isDelivery ? 5.99 : 0
        )
        
        if let newOrder = order {
            self.orders.orders.append(newOrder)
        }
        return true
    }
 
    func reset() {
        type = "Photo"
        size = "4x6"
        quantity = 1
        name = ""
        phone = ""
        promotionCode = ""
        isDelivery = false
        showReceipt = false
        showAlert = false
    }
    
    var body: some View {
        
        NavigationStack {
            VStack{
                Form {
                    Section(header: Text("Options")) {
                        Picker("Print Type", selection: $type) {
                            Text("Photo").tag("Photo")
                            Text("Canvas").tag("Canvas")
                        }
                        .onChange(of: type) { _ in
                            size = sizes[type]!.first!
                            quantity = type == "Photo" ? 1 : 3
                        }
                        
                        Picker("Print Size", selection: $size) {
                            ForEach(sizes[type]!, id: \.self) { size in
                                Text(size).tag(size)
                            }
                        }
                        
                        Stepper("Quantity: \(quantity)", value: $quantity, in: (type == "Photo" ? 1 : 3)...10)
                        Toggle("Delivery ($5.99)", isOn: $isDelivery)
                    }
                    
                    
                    Section(header: Text("Info")) {
                        TextField("Name", text: $name)
                            .keyboardType(.default)
                        TextField("Phone Number", text: $phone)
                            .keyboardType(.phonePad)
                    }
                    
                    
                    Section(header: Text("Discount")) {
                        TextField("Coupon Code (optional)", text: $promotionCode)
                    }
                    
                    Section {
                        Button("Place Order") {
                            self.showReceipt = placeOrder()
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Error Coupon"),
                                message: Text("You Must Enter the Correct Coupon Code"),
                                dismissButton: .default(Text("OK")) {
                                    promotionCode = ""
                                }
                            )
                        }
//                        .alert(isPresented: $showReceipt) {
//                            Alert(
//                                title: Text("Print Successfully"),
//                                message: Text("Waiting for Your Receipt"),
//                                dismissButton: .default(Text("OK")) {
//                                    reset()
//                                }
//                            )
//                        }
                        
                    }
                    .disabled(phone.isEmpty)
                    .disabled(name.isEmpty)
                    
                } // Form
                .scrollContentBackground(.hidden)
                .background(.clear)
                .background {
                    Image("wallpaper")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .blur(radius: 3)
                        .opacity(0.25)}
            } // NavigationStack
            .navigationTitle("GBC Print Store")
            .navigationDestination(isPresented: $showReceipt) {
                if let newOrder = order {
                    ReceiptDetail(order: newOrder)
                }
            }
            .toolbar {
                Button("Reset") {
                    reset()
                }
            }
        } // NavigationStack
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
    }// View

}

#Preview {
    PrintSelection()
}
