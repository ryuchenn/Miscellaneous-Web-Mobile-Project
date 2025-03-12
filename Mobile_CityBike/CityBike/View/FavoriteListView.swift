//
//  FavoriteListView.swift
//  CityBike
//
//  Created by admin on 2025-03-12.
//
import SwiftUI

struct FavoriteListView: View {
    @State private var favs: [DataField] = []
    let firebase = DBController()
    @State private var selection: Set<String> = []
    @State private var editMode: EditMode = .inactive
    @State private var showDeleteAlert: Bool = false
    @State private var searchText: String = ""
    
    var filteredFavs: [DataField] {
        if searchText.isEmpty {
            return favs
        } else {
            return favs.filter { $0.location.city.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                
                List(filteredFavs, id: \.id, selection: $selection) { net in
                    NavigationLink(destination: BikeDetailView(net: net)) {
                        VStack(alignment: .leading) {
                            Text(net.location.city)
                                .font(.headline)
                            Text(net.company.joined(separator: ", "))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            firebase.delete(net: net) { err in
                                if err == nil {
                                    load()
                                } else {
                                    print("Error deleting \(net.id): \(err?.localizedDescription ?? "")")
                                }
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search Favorites")
                .navigationTitle("Favorites")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if editMode == .active && !selection.isEmpty {
                            Button("Delete") {
                                showDeleteAlert = true
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            withAnimation {
                                editMode = (editMode == .active) ? .inactive : .active
                            }
                        } label: {
                            Image(systemName: editMode == .active ? "xmark" : "trash")
                        }
                    }
                }
                .environment(\.editMode, $editMode)
                .onAppear(perform: load)
                .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text("Confirm Deletion"),
                        message: Text("Are you sure you want to delete the selected favorites?"),
                        primaryButton: .destructive(Text("Delete")) {
                            batchDelete()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }
    
    func load() {
        firebase.fetch { nets, err in
            if let nets = nets {
                favs = nets
            } else {
                print("Error fetching favorites: \(err?.localizedDescription ?? "")")
            }
        }
    }
    
    func batchDelete() {
        let dispatchGroup = DispatchGroup()
        
        for id in selection {
            if let net = favs.first(where: { $0.id == id }) {
                dispatchGroup.enter()
                firebase.delete(net: net) { err in
                    if let err = err {
                        print("Error deleting \(net.id): \(err.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            selection.removeAll()
            load()
            withAnimation {
                editMode = .inactive
            }
        }
    }
}
