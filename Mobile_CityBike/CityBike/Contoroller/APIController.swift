//
//  NetworkController.swift
//  CityBike
//
//  Created by admin on 2025-03-12.
//

import Foundation
import Alamofire
import SwiftUI

/// Fetching network data from the CityBike API ("https://api.citybik.es/v2/networks")
class APIController: ObservableObject {
    @Published var nets: [DataField] = []
    
    func fetch() {
        let apiURL = "https://api.citybik.es/v2/networks"
        
        AF.request(apiURL)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    // For Test DEBUG
//                    if let jsonString = String(data: data, encoding: .utf8) {
//                        print("Received JSON: \(jsonString)")
//                    }
                    do {
                        let decoded = try JSONDecoder().decode(DataFields.self, from: data)
                        DispatchQueue.main.async {
                            self.nets = decoded.networks
                        }
                    } catch {
                        print("Decoding Networks Failed: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("Fetching networks failed: \(error.localizedDescription)")
                }
            }
    }
}
