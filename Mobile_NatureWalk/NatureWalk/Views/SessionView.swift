//
//  Session.swift
//  NatureWalk
//
//  Created by admin on 2025-02-06.
//

import SwiftUI

struct SessionView: View {
    @State private var showSetting: Bool = false
    @StateObject private var lastUpdated = LastUpdated()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(sessions) { session in
                        NavigationLink(
                            destination: SessionDetailView(session: session).environmentObject(lastUpdated)
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                Image(session.photos[0])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 180)
                                    .cornerRadius(10) // Cover

                                Text(session.name)
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading) // Name

                                HStack(spacing: 0) {
                                    ForEach(1...5, id: \.self) { index in
                                        Image(systemName: Double(index) <= session.rating ? "star.fill" : "star")
                                            .font(.system(size: 14))
                                            .foregroundColor(.yellow)
                                    }
                                } // Rating

                                Text(session.description)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .lineLimit(4)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading) // Description

                                HStack {
                                    Text(session.date, style: .date)
                                        .font(.footnote)
                                        .foregroundColor(.gray)

                                    Spacer()
                                    
                                    Text("\(session.price, specifier: "CA$%.2f")")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(Color("Primary"))
                                } // Footer
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(
                                color: Color.black.opacity(0.2),
                                radius: 5,
                                x: 0,
                                y: 2
                            ) // Card
                        } // NavigationLink
                    } // ForEach
                }
                .padding()
                .background(Color("Gray100"))
                .navigationBarTitle(Text("Sessions"))
                .navigationBarItems(trailing:
                    Button(action: { self.showSetting = true }) {
                        AsyncImage(url: URL(string:  AccountService.avatar())) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 42, height: 42)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                    }
                )
            }
            .background(Color("Gray100"))
            .navigationDestination(isPresented: $showSetting){
                SettingView()
            } // ScrollView
        } // NavigationStack
    } // body
}

#Preview {
    SessionView()
}
