//
//  LastUpdated.swift
//  NatureWalk
//
//  Created by joeyin on 2025/2/9.
//

import Foundation

class LastUpdated: ObservableObject {
    @Published var datetime = Date()
    
    func update() {
        datetime = Date()
    }
}
