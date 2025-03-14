//
//  useAlert.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/12.
//

import Foundation

enum AlertType: String, CaseIterable {
    case Success = "Success"
    case Error = "Error"
    case Info = "Info"
}

class useAlert: ObservableObject {
    @Published var state: Bool = false
    @Published var title: AlertType = AlertType.Info
    @Published var messages = [String]()
    
    func toggle() {
        state.toggle()
    }
    
    func show(_ type: AlertType = .Info) {        
        self.state = true
        self.title = type
    }
    
    func hide() {
        state = false
    }
    
    func reset() {
        self.type(.Info)
        messages.removeAll()
    }
    
    func type(_ type: AlertType) {
        self.title = type
    }
    
    func append(_ message: String) {
        messages.append(message)
    }
}
