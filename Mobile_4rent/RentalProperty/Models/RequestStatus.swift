//
//  RequestStatus.swift
//  RentalProperty
//
//  Created by admin on 2025-03-09.
//

enum RequestStatus: String, Codable, CaseIterable {
    case pending = "Pending"
    case approved = "Approved"
    case rejected = "Reject"
}
