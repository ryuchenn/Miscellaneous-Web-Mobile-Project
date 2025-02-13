//
//  SessionDetail.swift
//  NatureWalk
//
//  Created by admin on 2025-02-06.
//

import SwiftUI

struct SessionDetailView: View {
    let session: Session
    @State var photo: String = ""
    @State private var isLiked: Bool = false
    @State private var showAlertMsg = false
    @EnvironmentObject var lastUpdated: LastUpdated
    
    var body: some View {
        VStack {
            ZStack {
                ZStack {
                    if !photo.isEmpty {
                        Image(photo)
                            .resizable()
                            .scaledToFill()
                            .opacity(0.52)
                            .frame(height: 350)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                VStack {
                    Spacer()
                    
                    HStack {
                        ForEach(session.photos, id: \.self) { photo in
                            Button(action: {
                                self.photo = photo
                            }) {
                                Circle()
                                    .fill(self.photo == photo ? Color("Primary") : Color.white)
                                    .frame(width: 12, height: 12)
                                    .shadow(
                                        color: Color.black.opacity(0.38),
                                        radius: 5,
                                        x: 0,
                                        y: 0
                                    )
                            }
                        }
                    }
                    .padding()
                                        
                    VStack {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 15) {
                                VStack(spacing: 3) {
                                    Text("Name")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(session.name)
                                        .font(.title3)
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                } // Name
                                
                                VStack(spacing: 3) {
                                    Text("Rating")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    HStack(spacing: 0) {
                                        ForEach(1...5, id: \.self) { index in
                                            Image(systemName: Double(index) <= session.rating ? "star.fill" : "star")
                                                .font(.callout)
                                                .foregroundColor(.yellow)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                } // Rating
                                
                                VStack(spacing: 3) {
                                    Text("Organization")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Button(action: {
                                        let tel = "tel://" + session.phone
                                        guard let url = URL(string: tel) else { return }
                                        UIApplication.shared.open(url)
                                    }) {
                                        Text(session.hosting)
                                            .font(.callout)
                                            .foregroundColor(.primary)
                                            .underline()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                } // Host
                                
                                VStack(spacing: 3) {
                                    Text("Date & Time")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(session.date.formatted(.dateTime.year().month().day().hour().minute().second()))
                                        .font(.callout)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } // Date
                                
                                VStack(spacing: 3) {
                                    Text("Location")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(session.address)
                                        .font(.callout)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                } // Location
                                
                                VStack(spacing: 3) {
                                    Text("Description")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(session.description)
                                        .font(.callout)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                } // Description
                                
                                VStack(spacing: 3) {
                                    Text("Photos")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 10) {
                                            // Showcase a few photos (only two photos make it difficult to appeal to users to book the event)
                                            ForEach([1, 2, 3], id: \.self) { _ in
                                                ForEach(session.photos, id: \.self) { photo in
                                                    Image(photo)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 180, height: 108)
                                                        .cornerRadius(8)
                                                }
                                            }
                                        }
                                    }
                                } // Photos
                            } // Detail
                        } // ScrollView
                        .padding(.bottom, 10)
                        
                        Button(action: {
                            showAlertMsg = true
                        }) {
                            Text("Book Now! \(session.price, specifier: "CA$%.2f")")
                                .foregroundColor(.white)
                                .padding(12)
                                .frame(maxWidth: .infinity)
                                .font(.headline)
                                .bold()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color("Primary")) // Book
                    }
                    .frame(maxWidth: .infinity, maxHeight: 520, alignment: .leading)
                    .padding(30)
                    .background(.white)
                    .cornerRadius(30)
                    .shadow(
                        color: Color.black.opacity(0.2),
                        radius: 5,
                        x: 0,
                        y: -2
                    ) // Card
                }
                .frame(width: UIScreen.main.bounds.width, alignment: .top) // Content
            }
        }
        .navigationBarItems(trailing:
            HStack(spacing: 3) {
                Button(action: {
                    _ = FavoriteHelper.toggle(session.id)
                    isLiked = FavoriteHelper.contains(session.id)
                    lastUpdated.update()
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(isLiked ? .red.opacity(0.8) : .secondary)
                        .padding(12)
                        .background(.white.opacity(0.88))
                        .clipShape(Circle())
                        .frame(width: 42, height: 42)
                } // Like
            
                ShareLink(
                    items: [
                        "I would like to share an exciting event with you! Join us for \(session.name):",
                        "https://www.naturewalk.com/session/\(session.id)"
                    ]
                ) {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(.black)
                        .padding(12)
                        .background(.white.opacity(0.88))
                        .clipShape(Circle())
                        .frame(width: 42, height: 42)
                } // Share
            }
        )
        .onAppear() {
            // Get the liked status
            isLiked = FavoriteHelper.contains(session.id)
            photo = session.photos[0]
        }
        .alert(isPresented: $showAlertMsg) {
            // For demo use only
            Alert(
                title: Text("Booking Confirmed"),
                message: Text("Congratulations! You’ve successfully booked the \(session.name) session.")
            )
        }
        .toolbar(.hidden, for: .tabBar) // hide tabBar
        .edgesIgnoringSafeArea(.all) // container
    } // body
}

#Preview {
    SessionDetailView(session: sessions[4], photo: sessions[4].photos[0])
}
