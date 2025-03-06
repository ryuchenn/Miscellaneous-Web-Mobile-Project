//
//  PlantController.swift
//  ChiaHung_Plants
//
//  Created by admin on 2025-03-05.
//
import Foundation

class PlantController: ObservableObject {
    @Published var plants: [Plant] = []
    
    func loadData() {
        DatabaseHelper.instance.get { [weak self] fetchedPlants in
            DispatchQueue.main.async {
                self?.plants = fetchedPlants
            }
        }
    }
    
    func add(_ plant: Plant, completion: @escaping (Error?) -> Void) {
        DatabaseHelper.instance.add(plant) { [weak self] error in
            if error == nil { self?.loadData() }
            completion(error)
        }
    }
    
    func delete(_ plant: Plant) {
        DatabaseHelper.instance.delete(plant) { [weak self] error in
            if error == nil { self?.loadData() }
        }
    }
    
    func update(_ plant: Plant, completion: @escaping (Error?) -> Void) {
        DatabaseHelper.instance.update(plant) { [weak self] error in
            if error == nil { self?.loadData() }
            completion(error)
        }
    }
}
