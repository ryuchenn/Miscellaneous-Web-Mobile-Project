//
//  Package.swift
//  ChiaHung_Final
//
//  Created by admin on 2025-02-11.
//

import Foundation

// Models
struct Package: Identifiable, Codable {
    let id = UUID()
    var PID: String
    var address: String
    var date: Date
    var carrier: String
    var status: Bool // true: Delivered, false: In Transit
}

// ViewModels
class PackageHelper: ObservableObject {
    @Published var searchText: String = ""
    
    @Published var packages: [Package] = [] {
        didSet {
            save()
        }
    }
    init() {
        get()
    }
    
    func get() {
        if let savedData = UserDefaults.standard.data(forKey: "Packages"),
           let decoded = try? JSONDecoder().decode([Package].self, from: savedData) {
            packages = decoded
        }
    }
    
    var search: [Package] {
        if searchText.isEmpty {
            return packages
        } else {
            return packages.filter { package in
                let searchString = package.status ?  shipStatus.delivered.rawValue : shipStatus.inTransit.rawValue
                return package.PID.lowercased().contains(searchText.lowercased()) || searchString.lowercased().contains(searchText.lowercased())
            }
        }
    }

    func add(_ package: Package) {
        packages.append(package)
    }
    
    func update(_ package: Package) {
        if let index = packages.firstIndex(where: { $0.id == package.id }) {
            packages[index] = package
        }
    }
    
    func remove(at offsets: IndexSet) {
        packages.remove(atOffsets: offsets)
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(packages) {
            UserDefaults.standard.set(encoded, forKey: "Packages")
        }
    }
}

