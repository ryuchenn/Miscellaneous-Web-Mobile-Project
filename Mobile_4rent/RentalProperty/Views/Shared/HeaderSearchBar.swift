//
//  SearchBar.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/10.
//

import SwiftUI

struct HeaderSearchBar: View {
    @State var keyword: String = ""
    @State var type: PropertyType?
        
    let defaultItems: [Property]
    @State var items = [Property]()
    @Binding var result: [Property]
    
    func renderButton(_ name: String, _ value: PropertyType?) -> some View {
        let active = type == value
        
        return Button(name) {
            type = value
        }
        .font(.system(size: 12, weight: .medium))
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(active ? Color.white : Color.clear)
        .foregroundColor(active ? Color("AccentColor") : Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.white, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
    
    func filterItems() {
        let keyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                
        if keyword.isEmpty && type == nil {
            self.items = defaultItems
        } else {
            self.items = defaultItems.filter { property in
                let matchesKeyword = keyword.isEmpty ||
                    (property.communityName?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().contains(keyword) ?? false)
                
                let matchesPropertyType = type == nil ||
                    property.propertyType == type?.rawValue
                
                return matchesKeyword && matchesPropertyType
            }
        }
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 15) {
                VStack {
                    HStack {
                        VStack {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 13))
                                .foregroundColor(.black.opacity(0.6))
                        }
                        .padding(.leading, 15)
                        .frame(height: 38)
                        
                        TextField(
                            "",
                            text: $keyword,
                            prompt: Text("Search by Name...").foregroundColor(.black.opacity(0.6))
                        )
                        .padding(.leading, 0)
                        .padding(.trailing, 15)
                        .frame(height: 38)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        
                    }
                    .frame(height: 38)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(6)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            renderButton("All", nil)
                            ForEach(PropertyType.allCases, id: \.self) { status in
                                renderButton(status.rawValue, status)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 15)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("AccentColor")) // Search
            .onChange(of: keyword) {
                filterItems()
            }
            .onChange(of: type) {
                filterItems()
            }
            .onChange(of: defaultItems.description) {
                self.items = defaultItems
            }
            .onChange(of: items.description) {
                self.result = items
            }
            
            HStack(spacing: 5) {
                Text(IntegerFormatter(Double(items.count)))
                    .foregroundStyle(Color("DarkBlueColor"))
                    .bold()

                Text("Result Found")
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            .font(.system(size: 14))
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
