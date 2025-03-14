//
//  useToggle.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/12.
//

import Foundation

class useToggle: ObservableObject, CustomStringConvertible {
    @Published var state: Bool
    
    var description: String {
        return "\(state)"
    }
    
    init(initialState: Bool = false) {
        self.state = initialState
    }
    
    func toggle() {
        state.toggle()
    }
    
    func on() {
        state = true
    }
    
    func off() {
        state = false
        print("updated")
    }
}
