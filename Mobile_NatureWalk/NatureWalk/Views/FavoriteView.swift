////
////  Favorite.swift
////  NatureWalk
////
////  Created by admin on 2025-02-06.
////
////

import SwiftUI

enum Layout {
    case List
    case Card
}

struct FavoriteView: View {
    @State private var favorites = [Session]()
    @State private var showSetting: Bool = false
    @State private var selectedFavoriteIds: Set<Session.ID> = []
    @State private var layoutMode = Layout.Card
    @State private var editMode: EditMode = EditMode.inactive
    @StateObject private var lastUpdated = LastUpdated()  // Notify that the favorites should be updated.

    func renderContentView() -> some View {
        Group {
            if favorites.isEmpty {
                Text("No favorites yet.")
                    .foregroundColor(.gray)
                    .padding()
                    .font(.subheadline)
            } else {
                layoutMode == .List ? AnyView(renderListView()) : AnyView(renderCardView())
            }
        }
    }
    
    func renderListView() -> some View {
        List(favorites, id: \.id, selection: $selectedFavoriteIds) { session in
            NavigationLink(
                destination: SessionDetailView(session: session).environmentObject(lastUpdated)
            ) {
                HStack {
                    Image(session.photos[0])
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 80)
                        .cornerRadius(10) // Cover

                    VStack(alignment: .leading, spacing: 5) {
                        Text(session.name)
                            .font(.headline)
                            .foregroundColor(.primary) // Name

                        HStack(spacing: 0) {
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: Double(index) <= session.rating ? "star.fill" : "star")
                                    .font(.system(size: 12))
                                    .foregroundColor(.yellow)
                            }
                        } // Ranking

                        Text(session.date, style: .date)
                            .font(.footnote)
                            .foregroundColor(.gray) // Date
                    }
                    .padding(.horizontal, 6) // Detail
                }
                .padding(.vertical, 6) // Card
            } // NavigationLink
        }
        .listStyle(InsetGroupedListStyle()) // List
    }

    func renderCardView() -> some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(favorites) { session in
                    ZStack {
                        NavigationLink(
                            destination: SessionDetailView(session: session).environmentObject(lastUpdated)
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                Image(session.photos[0])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 180)
                                    .clipped()
                                    .cornerRadius(10) // Image Cover

                                Text(session.name)
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading) // Session Name

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
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                            .onLongPressGesture {
                                selectedFavoriteIds = [session.id]
                            } // Card
                        }

                        if selectedFavoriteIds.contains(session.id) {
                            VStack {
                                Button(action: {
                                    _ = FavoriteHelper.toggle(session.id)
                                    lastUpdated.update()
                                }) {
                                    Image(systemName: "trash")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(16)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(Color("Primary"))
                                        .shadow(color: Color.white.opacity(0.2), radius: 5)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color("Primary").opacity(0.88))
                            .cornerRadius(12)
                        }
                    }
                }
            }
            .padding()
        }
        .onTapGesture {
            selectedFavoriteIds.removeAll()
        }
    }
    
    func reset() {
        selectedFavoriteIds.removeAll()
        layoutMode = .Card
        editMode = .inactive
    }

    func toggleLayout() {
        layoutMode = (layoutMode == .Card) ? .List : .Card
        editMode = .inactive
        selectedFavoriteIds.removeAll()
    }
    
    func handleDelete() {
        for id in selectedFavoriteIds {
            _ = FavoriteHelper.remove(id)
        }
        lastUpdated.update()
    }

    var body: some View {
        NavigationStack {
            Group {
                if favorites.isEmpty {
                    Text("No favorites yet.")
                        .foregroundColor(.gray)
                        .padding()
                        .font(.subheadline)
                } else {
                    layoutMode == .List ? AnyView(renderListView()) : AnyView(renderCardView())
                }
            }
            .background(Color("Gray100"))
            .navigationTitle("Favorites")
            .navigationBarItems(
                leading:
                    HStack(spacing: 0) {
                        if (layoutMode == .List) {
                            EditButton()
                            
                            if (editMode.isEditing) {
                                // Selecting all favorites: The logic follows that of Apple Mail
                                let isAllSelected = selectedFavoriteIds.count == favorites.count
                                Button(action: {
                                    selectedFavoriteIds = isAllSelected ? Set() : Set(favorites.map { $0.id })
                                }) {
                                    VStack {
                                        Text("Select All")
                                            .font(.footnote)
                                            .padding(0)
                                            .foregroundColor(.gray.opacity(0.8))
                                            .frame(height: 15)
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 18)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                                    )
                                }

                                Button(action: {
                                    withAnimation {
                                        handleDelete()
                                    }
                                }) {
                                    VStack {
                                        Image(systemName: "trash")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.white)
                                            .frame(width: 15, height: 15)
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 18)
                                    .background(selectedFavoriteIds.isEmpty ? Color.gray.opacity(0.5) : Color.red.opacity(0.88))
                                    .cornerRadius(8)
                                }
                                .disabled(selectedFavoriteIds.isEmpty)
                            }
                        }
                    },
                trailing:
                    HStack {
                        Button(action: toggleLayout) {
                            Image(systemName: layoutMode == .Card ? "list.bullet" : "rectangle.grid.1x2")
                        }
                        
                        Button(action: { self.showSetting = true }) {
                            AsyncImage(url: URL(string: AccountService.avatar())) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 42, height: 42)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
            )
            .environment(\.editMode, $editMode)
            .navigationDestination(isPresented: $showSetting) {
                SettingView()
            } // Container
        }
        .onAppear {
            lastUpdated.update()
        }
        .onDisappear {
            reset()
        }
        .onChange(of: lastUpdated.datetime) { _ in
            let favoritesIds = FavoriteHelper.all().filter { $0.userId == AccountService.id() }.map { $0.sessionId }
            favorites = sessions.filter { favoritesIds.contains($0.id) }
            print("Favorites have been updated.")
        }
    }
}

#Preview {
    FavoriteView()
}
